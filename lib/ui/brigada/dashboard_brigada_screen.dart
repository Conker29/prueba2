import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import '../../logic/vacunacion_provider.dart';
import '../../models/vacunacion_model.dart';
import '../widgets/estado_widgets.dart';
import '../campana/dashboard_campana_screen.dart' show DashboardBodyExport;
import 'crear_vacunador_screen.dart';
import 'asignar_vacunador_screen.dart';
import 'correccion_registros_screen.dart';

class DashboardBrigadaScreen extends StatelessWidget {
  const DashboardBrigadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario!;
    final vacProv = context.read<VacunacionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Brigada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(usuario.nombreCompleto,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 18)),
                  const Text('Coordinador de Brigada',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Mis sectores'),
              subtitle: Text(usuario.sectoresAsignados.join(', ')),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Crear vacunador'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CrearVacunadorScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Asignar / Reasignar vacunadores'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AsignarVacunadorScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Corregir registros'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CorreccionRegistrosScreen())),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<VacunacionModel>>(
        stream: vacProv.porSector(usuario.sectoresAsignados),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const CargandoWidget();
          }
          if (snap.hasError) return ErrorWidget2(snap.error.toString());
          return DashboardBodyExport(datos: snap.data ?? []);
        },
      ),
    );
  }
}