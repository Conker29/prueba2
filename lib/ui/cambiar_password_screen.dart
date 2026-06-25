import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/auth_provider.dart';
import 'widgets/estado_widgets.dart';

class CambiarPasswordScreen extends StatefulWidget {
  const CambiarPasswordScreen({super.key});
  @override
  State<CambiarPasswordScreen> createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nueva = TextEditingController();
  final _confirmar = TextEditingController();
  bool _cargando = false;

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);
    final ok = await context.read<AuthProvider>().cambiarPassword(_nueva.text);
    setState(() => _cargando = false);
    if (ok && mounted) {
      mostrarSnack(context, 'Contraseña actualizada');
    } else if (mounted) {
      mostrarSnack(context, 'Error al actualizar', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambio obligatorio de contraseña'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                  'Por seguridad debe cambiar su contraseña inicial.'),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nueva,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Nueva contraseña'),
                validator: (v) =>
                    v!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmar,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirmar contraseña'),
                validator: (v) =>
                    v != _nueva.text ? 'No coinciden' : null,
              ),
              const SizedBox(height: 24),
              _cargando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _guardar,
                      child: const Text('Guardar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}