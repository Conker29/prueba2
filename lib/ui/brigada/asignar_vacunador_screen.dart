import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/usuario_provider.dart';
import '../../models/usuario_model.dart';
import '../widgets/estado_widgets.dart';

class AsignarVacunadorScreen extends StatelessWidget {
  const AsignarVacunadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final prov = context.read<UsuarioProvider>();
    final misSectores = auth.usuario!.sectoresAsignados;

    return Scaffold(
      appBar: AppBar(title: const Text('Asignar / Reasignar vacunadores')),
      body: StreamBuilder<List<UsuarioModel>>(
        stream: prov.vacunadoresDe(auth.usuario!.uid),
        builder: (context, snap) {
          if (!snap.hasData) return const CargandoWidget();
          final vacunadores = snap.data!;
          if (vacunadores.isEmpty) {
            return const Center(child: Text('No hay vacunadores creados'));
          }
          return ListView.builder(
            itemCount: vacunadores.length,
            itemBuilder: (_, i) {
              final v = vacunadores[i];
              return ExpansionTile(
                leading: const Icon(Icons.person),
                title: Text(v.nombreCompleto),
                subtitle: Text('Sectores: ${v.sectoresAsignados.join(", ")}'),
                children: misSectores.map((s) {
                  final asignado = v.sectoresAsignados.contains(s);
                  return CheckboxListTile(
                    title: Text(s),
                    value: asignado,
                    onChanged: (val) async {
                      final nuevos = List<String>.from(v.sectoresAsignados);
                      val == true ? nuevos.add(s) : nuevos.remove(s);
                      await prov.asignarSectores(v.uid, nuevos);
                      if (context.mounted) {
                        mostrarSnack(context, 'Sectores actualizados');
                      }
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}