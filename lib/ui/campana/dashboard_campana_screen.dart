import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../logic/auth_provider.dart';
import '../../logic/vacunacion_provider.dart';
import '../../models/vacunacion_model.dart';
import '../widgets/estado_widgets.dart';
import 'crear_sector_screen.dart';
import 'crear_coordinador_screen.dart';

class DashboardCampanaScreen extends StatelessWidget {
  const DashboardCampanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vacProv = context.read<VacunacionProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard General'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          )
        ],
      ),
      drawer: _menu(context),
      body: StreamBuilder<List<VacunacionModel>>(
        stream: vacProv.todas(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const CargandoWidget();
          }
          if (snap.hasError) return ErrorWidget2(snap.error.toString());
          final datos = snap.data ?? [];
          return _DashboardBody(datos: datos);
        },
      ),
    );
  }

  Widget _menu(BuildContext context) => Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Coordinador de Campaña',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt),
              title: const Text('Crear sector'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CrearSectorScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Crear coordinador de brigada'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CrearCoordinadorScreen())),
            ),
          ],
        ),
      );
}

/// Widget reutilizable para mostrar las métricas del dashboard
class _DashboardBody extends StatelessWidget {
  final List<VacunacionModel> datos;
  const _DashboardBody({required this.datos});

  @override
  Widget build(BuildContext context) {
    final total = datos.length;
    final perros = datos.where((v) => v.tipoMascota == 'perro').length;
    final gatos = datos.where((v) => v.tipoMascota == 'gato').length;
    final pendientes = datos.where((v) => !v.sincronizado).length;

    // Agrupar por sector
    final porSector = <String, int>{};
    for (final v in datos) {
      porSector[v.sector] = (porSector[v.sector] ?? 0) + 1;
    }
    // Agrupar por vacunador
    final porVacunador = <String, int>{};
    for (final v in datos) {
      porVacunador[v.vacunadorNombre] =
          (porVacunador[v.vacunadorNombre] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _Card('Total', total, Icons.vaccines, Colors.blue),
              _Card('Perros', perros, Icons.pets, Colors.brown),
              _Card('Gatos', gatos, Icons.pets, Colors.orange),
              _Card('Pendientes sync', pendientes, Icons.sync_problem,
                  Colors.red),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Vacunaciones por sector',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _BarChart(data: porSector),
          const SizedBox(height: 24),
          const Text('Vacunaciones por vacunador',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...porVacunador.entries.map((e) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(e.key),
                trailing: Text('${e.value}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              )),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String titulo;
  final int valor;
  final IconData icono;
  final Color color;
  const _Card(this.titulo, this.valor, this.icono, this.color);

  @override
  Widget build(BuildContext context) => Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: color, size: 30),
              const SizedBox(height: 6),
              Text('$valor',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(titulo, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

class _BarChart extends StatelessWidget {
  final Map<String, int> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Text('Sin datos');
    final keys = data.keys.toList();
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: true)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < keys.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(keys[i],
                          style: const TextStyle(fontSize: 9)),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          barGroups: List.generate(
            keys.length,
            (i) => BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                  toY: data[keys[i]]!.toDouble(), color: Colors.green)
            ]),
          ),
        ),
      ),
    );
  }
}


class DashboardBodyExport extends StatelessWidget {
  final List<VacunacionModel> datos;
  const DashboardBodyExport({super.key, required this.datos});
  @override
  Widget build(BuildContext context) => _DashboardBody(datos: datos);
}