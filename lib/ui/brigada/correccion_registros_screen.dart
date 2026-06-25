import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import '../../logic/vacunacion_provider.dart';
import '../../models/vacunacion_model.dart';
import '../widgets/estado_widgets.dart';
import '../vacunador/registro_vacunacion_screen.dart';

/// El coordinador de brigada puede corregir CUALQUIER registro de su sector
class CorreccionRegistrosScreen extends StatelessWidget {
  const CorreccionRegistrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.read<AuthProvider>().usuario!;
    final prov = context.read<VacunacionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Corregir registros del sector')),
      body: StreamBuilder<List<VacunacionModel>>(
        stream: prov.porSector(usuario.sectoresAsignados),
        builder: (context, snap) {
          if (!snap.hasData) return const CargandoWidget();
          final lista = snap.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('No hay registros'));
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (_, i) {
              final v = lista[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                        v.tipoMascota == 'perro' ? Icons.pets : Icons.pets),
                  ),
                  title: Text('${v.nombreMascota} (${v.tipoMascota})'),
                  subtitle: Text(
                      'Prop: ${v.propietarioNombre}\nSector: ${v.sector} • ${v.vacunadorNombre}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.edit),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RegistroVacunacionScreen(registroExistente: v),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}