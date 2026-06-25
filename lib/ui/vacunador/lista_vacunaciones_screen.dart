import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/auth_provider.dart';
import '../../logic/vacunacion_provider.dart';
import '../../models/vacunacion_model.dart';
import '../widgets/estado_widgets.dart';
import 'registro_vacunacion_screen.dart';

/// El vacunador ve y edita SOLO sus registros
class ListaVacunacionesScreen extends StatelessWidget {
  const ListaVacunacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.read<AuthProvider>().usuario!;
    final prov = context.read<VacunacionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis registros')),
      body: StreamBuilder<List<VacunacionModel>>(
        stream: prov.porVacunador(usuario.uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const CargandoWidget();
          }
          if (snap.hasError) return ErrorWidget2(snap.error.toString());
          final lista = snap.data ?? [];
          if (lista.isEmpty) {
            return const Center(child: Text('Aún no tiene registros'));
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (_, i) {
              final v = lista[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        v.tipoMascota == 'perro' ? Colors.brown : Colors.orange,
                    child: const Icon(Icons.pets, color: Colors.white),
                  ),
                  title: Text('${v.nombreMascota} • ${v.tipoMascota}'),
                  subtitle: Text(
                      '${v.propietarioNombre}\n${DateFormat('dd/MM/yyyy HH:mm').format(v.fechaHora)}'),
                  isThreeLine: true,
                  trailing: Icon(
                    v.sincronizado ? Icons.cloud_done : Icons.cloud_off,
                    color: v.sincronizado ? Colors.green : Colors.grey,
                  ),
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