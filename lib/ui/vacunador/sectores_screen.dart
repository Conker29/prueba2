import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import '../../logic/sync_provider.dart';
import 'registro_vacunacion_screen.dart';
import 'lista_vacunaciones_screen.dart';

class SectoresScreen extends StatefulWidget {
  const SectoresScreen({super.key});
  @override
  State<SectoresScreen> createState() => _SectoresScreenState();
}

class _SectoresScreenState extends State<SectoresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sync = context.read<SyncProvider>();
      await sync.actualizarContador();
      await sync.sincronizar(); // intenta subir pendientes al abrir
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario!;
    final sync = context.watch<SyncProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Sectores'),
        actions: [
          // Indicador de pendientes de sincronización
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Chip(
                avatar: sync.sincronizando
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_upload, size: 18),
                label: Text('${sync.pendientes}'),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ListaVacunacionesScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: usuario.sectoresAsignados.isEmpty
          ? const Center(child: Text('No tiene sectores asignados'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: usuario.sectoresAsignados.length,
              itemBuilder: (_, i) {
                final sector = usuario.sectoresAsignados[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text(sector),
                    subtitle: const Text('Toque para registrar vacunación'),
                    trailing: const Icon(Icons.add_circle, color: Colors.green),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RegistroVacunacionScreen(sectorPreseleccionado: sector),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}