import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'widgets/estado_widgets.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});
  @override
  State<RecuperarPasswordScreen> createState() => _State();
}

class _State extends State<RecuperarPasswordScreen> {
  final _correo = TextEditingController();

  Future<void> _enviar() async {
    if (_correo.text.isEmpty) return;
    await context.read<AuthProvider>().recuperarPassword(_correo.text.trim());
    if (mounted) {
      mostrarSnack(context, 'Correo de recuperación enviado');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextFormField(
              controller: _correo,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: _enviar, child: const Text('Enviar enlace')),
          ],
        ),
      ),
    );
  }
}