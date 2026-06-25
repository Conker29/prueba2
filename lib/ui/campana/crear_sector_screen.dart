import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/sector_provider.dart';
import '../../models/sector_model.dart';
import '../widgets/estado_widgets.dart';

class CrearSectorScreen extends StatefulWidget {
  const CrearSectorScreen({super.key});
  @override
  State<CrearSectorScreen> createState() => _CrearSectorScreenState();
}

class _CrearSectorScreenState extends State<CrearSectorScreen> {
  final _nombre = TextEditingController();
  bool _cargando = false;

  Future<void> _crear() async {
    if (_nombre.text.isEmpty) return;
    setState(() => _cargando = true);
    try {
      await context.read<SectorProvider>().crearSector(_nombre.text.trim());
      _nombre.clear();
      if (mounted) mostrarSnack(context, 'Sector creado');
    } catch (e) {
      if (mounted) mostrarSnack(context, 'Error', error: true);
    }
    setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.read<SectorProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sectores')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nombre,
                    decoration:
                        const InputDecoration(labelText: 'Nombre del sector'),
                  ),
                ),
                const SizedBox(width: 8),
                _cargando
                    ? const CircularProgressIndicator()
                    : IconButton.filled(
                        onPressed: _crear,
                        icon: const Icon(Icons.add)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<SectorModel>>(
              stream: prov.obtenerSectores(),
              builder: (context, snap) {
                if (!snap.hasData) return const CargandoWidget();
                final sectores = snap.data!;
                return ListView.builder(
                  itemCount: sectores.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(sectores[i].nombre),
                    subtitle: Text(sectores[i].coordinadorBrigadaUid == null
                        ? 'Sin coordinador'
                        : 'Asignado'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}