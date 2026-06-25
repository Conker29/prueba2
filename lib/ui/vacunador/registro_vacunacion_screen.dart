import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../logic/auth_provider.dart';
import '../../logic/vacunacion_provider.dart';
import '../../logic/sync_provider.dart';
import '../../models/vacunacion_model.dart';
import '../widgets/estado_widgets.dart';

class RegistroVacunacionScreen extends StatefulWidget {
  final String? sectorPreseleccionado;
  final VacunacionModel? registroExistente; // para corrección

  const RegistroVacunacionScreen({
    super.key,
    this.sectorPreseleccionado,
    this.registroExistente,
  });

  @override
  State<RegistroVacunacionScreen> createState() => _State();
}

class _State extends State<RegistroVacunacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _propNombre = TextEditingController();
  final _propCedula = TextEditingController();
  final _telefono = TextEditingController();
  final _nombreMascota = TextEditingController();
  final _edad = TextEditingController();
  final _vacuna = TextEditingController();
  final _observaciones = TextEditingController();

  String _tipoMascota = 'perro';
  String _sexo = 'macho';
  File? _foto;
  Position? _posicion;
  bool _obteniendoGps = false;

  @override
  void initState() {
    super.initState();
    final r = widget.registroExistente;
    if (r != null) {
      _propNombre.text = r.propietarioNombre;
      _propCedula.text = r.propietarioCedula;
      _telefono.text = r.telefono;
      _nombreMascota.text = r.nombreMascota;
      _edad.text = r.edad;
      _vacuna.text = r.vacunaAplicada;
      _observaciones.text = r.observaciones;
      _tipoMascota = r.tipoMascota;
      _sexo = r.sexo;
    } else {
      _obtenerUbicacion();
    }
  }

  // ====== CÁMARA ======
  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 60, maxWidth: 1024);
    if (img != null) setState(() => _foto = File(img.path));
  }

  // ====== GPS ======
  Future<void> _obtenerUbicacion() async {
    setState(() => _obteniendoGps = true);
    try {
      bool servicio = await Geolocator.isLocationServiceEnabled();
      if (!servicio) {
        if (mounted) mostrarSnack(context, 'Active el GPS', error: true);
        setState(() => _obteniendoGps = false);
        return;
      }
      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.deniedForever ||
          permiso == LocationPermission.denied) {
        if (mounted) mostrarSnack(context, 'Permiso GPS denegado', error: true);
        setState(() => _obteniendoGps = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() => _posicion = pos);
    } catch (e) {
      if (mounted) mostrarSnack(context, 'Error GPS: $e', error: true);
    }
    setState(() => _obteniendoGps = false);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final esCorreccion = widget.registroExistente != null;

    if (!esCorreccion && _foto == null) {
      mostrarSnack(context, 'Debe tomar una fotografía', error: true);
      return;
    }
    if (!esCorreccion && _posicion == null) {
      mostrarSnack(context, 'Debe capturar la ubicación GPS', error: true);
      return;
    }

    final auth = context.read<AuthProvider>();
    final prov = context.read<VacunacionProvider>();

    final base = widget.registroExistente;

    final registro = VacunacionModel(
      id: base?.id ?? prov.nuevoId(),
      propietarioNombre: _propNombre.text.trim(),
      propietarioCedula: _propCedula.text.trim(),
      telefono: _telefono.text.trim(),
      tipoMascota: _tipoMascota,
      nombreMascota: _nombreMascota.text.trim(),
      edad: _edad.text.trim(),
      sexo: _sexo,
      vacunaAplicada: _vacuna.text.trim(),
      observaciones: _observaciones.text.trim(),
      fotoUrl: base?.fotoUrl ?? '',
      latitud: _posicion?.latitude ?? base?.latitud ?? 0,
      longitud: _posicion?.longitude ?? base?.longitud ?? 0,
      fechaHora: base?.fechaHora ?? DateTime.now(),
      sector: widget.sectorPreseleccionado ?? base!.sector,
      vacunadorUid: base?.vacunadorUid ?? auth.usuario!.uid,
      vacunadorNombre: base?.vacunadorNombre ?? auth.usuario!.nombreCompleto,
    );

    final ok = await prov.registrar(
        registro, _foto ?? File(base?.fotoUrl ?? ''));

    if (!mounted) return;
    if (ok) {
      await context.read<SyncProvider>().actualizarContador();
      mostrarSnack(context, esCorreccion ? 'Registro corregido' : 'Vacunación registrada');
      Navigator.pop(context);
    } else {
      mostrarSnack(context, prov.error ?? 'Error', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<VacunacionProvider>().estado;
    final esCorreccion = widget.registroExistente != null;

    return Scaffold(
      appBar: AppBar(
          title: Text(esCorreccion ? 'Corregir registro' : 'Registrar vacunación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sector: ${widget.sectorPreseleccionado ?? widget.registroExistente?.sector}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),

              // ===== DATOS PROPIETARIO =====
              _titulo('Datos del propietario'),
              _campo(_propNombre, 'Nombre del propietario'),
              _campo(_propCedula, 'Cédula', tipo: TextInputType.number),
              _campo(_telefono, 'Teléfono', tipo: TextInputType.phone),

              // ===== DATOS MASCOTA =====
              _titulo('Datos de la mascota'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _tipoMascota,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: const [
                        DropdownMenuItem(value: 'perro', child: Text('Perro')),
                        DropdownMenuItem(value: 'gato', child: Text('Gato')),
                      ],
                      onChanged: (v) => setState(() => _tipoMascota = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sexo,
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items: const [
                        DropdownMenuItem(value: 'macho', child: Text('Macho')),
                        DropdownMenuItem(value: 'hembra', child: Text('Hembra')),
                      ],
                      onChanged: (v) => setState(() => _sexo = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _campo(_nombreMascota, 'Nombre de la mascota'),
              _campo(_edad, 'Edad aproximada'),
              _campo(_vacuna, 'Vacuna aplicada'),
              _campo(_observaciones, 'Observaciones', obligatorio: false),

              // ===== FOTO =====
              _titulo('Fotografía'),
              _foto != null
                  ? Image.file(_foto!, height: 180, fit: BoxFit.cover)
                  : (esCorreccion &&
                          widget.registroExistente!.fotoUrl.startsWith('http')
                      ? Image.network(widget.registroExistente!.fotoUrl,
                          height: 180, fit: BoxFit.cover)
                      : Container(
                          height: 120,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Text('Sin fotografía'))),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _tomarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar fotografía'),
              ),

              // ===== GPS =====
              _titulo('Ubicación GPS'),
              if (_obteniendoGps)
                const Row(children: [
                  SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text('Obteniendo ubicación...')
                ])
              else if (_posicion != null)
                Text(
                    'Lat: ${_posicion!.latitude.toStringAsFixed(6)}\nLng: ${_posicion!.longitude.toStringAsFixed(6)}')
              else if (esCorreccion)
                Text(
                    'Lat: ${widget.registroExistente!.latitud}\nLng: ${widget.registroExistente!.longitud}')
              else
                const Text('Sin ubicación'),
              TextButton.icon(
                onPressed: _obtenerUbicacion,
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Actualizar GPS'),
              ),

              const SizedBox(height: 8),
              Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),

              const SizedBox(height: 24),
              estado == EstadoUI.cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _guardar,
                      icon: const Icon(Icons.save),
                      label: Text(esCorreccion ? 'Guardar cambios' : 'Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo(String t) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(t,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green)),
      );

  Widget _campo(TextEditingController c, String label,
      {TextInputType tipo = TextInputType.text, bool obligatorio = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: tipo,
        decoration: InputDecoration(labelText: label),
        validator: obligatorio
            ? (v) => v!.isEmpty ? 'Campo obligatorio' : null
            : null,
      ),
    );
  }
}