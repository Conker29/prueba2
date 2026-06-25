import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import '../../logic/usuario_provider.dart';
import '../../models/usuario_model.dart';
import '../../core/constants.dart';
import '../widgets/estado_widgets.dart';

class CrearVacunadorScreen extends StatefulWidget {
  const CrearVacunadorScreen({super.key});
  @override
  State<CrearVacunadorScreen> createState() => _State();
}

class _State extends State<CrearVacunadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedula = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _telefono = TextEditingController();
  final _correo = TextEditingController();
  final List<String> _sectoresSel = [];

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final prov = context.read<UsuarioProvider>();

    final nuevo = UsuarioModel(
      uid: '',
      cedula: _cedula.text.trim(),
      nombres: _nombres.text.trim(),
      apellidos: _apellidos.text.trim(),
      telefono: _telefono.text.trim(),
      correo: _correo.text.trim(),
      rol: Roles.vacunador,
      sectoresAsignados: _sectoresSel,
      creadoPor: auth.usuario!.uid,
    );

    final ok = await prov.crearUsuario(nuevo);
    if (!mounted) return;
    if (ok) {
      mostrarSnack(context,
          'Vacunador creado. Contraseña inicial: $passwordInicial');
      Navigator.pop(context);
    } else {
      mostrarSnack(context, prov.mensajeError ?? 'Error', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // El coordinador solo puede asignar a SUS sectores
    final misSectores = context.read<AuthProvider>().usuario!.sectoresAsignados;
    final estado = context.watch<UsuarioProvider>().estado;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear vacunador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campo(_cedula, 'Cédula', tipo: TextInputType.number),
              _campo(_nombres, 'Nombres'),
              _campo(_apellidos, 'Apellidos'),
              _campo(_telefono, 'Teléfono', tipo: TextInputType.phone),
              _campo(_correo, 'Correo', tipo: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Asignar a mis sectores:',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              ...misSectores.map((s) => CheckboxListTile(
                    title: Text(s),
                    value: _sectoresSel.contains(s),
                    onChanged: (v) => setState(() {
                      v == true ? _sectoresSel.add(s) : _sectoresSel.remove(s);
                    }),
                  )),
              const SizedBox(height: 24),
              estado == EstadoUI.cargando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _guardar, child: const Text('Crear')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController c, String label,
      {TextInputType tipo = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: tipo,
        decoration: InputDecoration(labelText: label),
        validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }
}