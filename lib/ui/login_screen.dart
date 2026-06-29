import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/sector_provider.dart';
import '../core/constants.dart';
import 'widgets/estado_widgets.dart' show mostrarSnack;
import 'recuperar_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _pass = TextEditingController();
  bool _verPass = false;

  @override
  void initState() {
    super.initState();
    // Precargar sectores la primera vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SectorProvider>().precargar(sectoresPrecargados);
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_correo.text.trim(), _pass.text.trim());
    if (!ok && mounted) {
      mostrarSnack(context, auth.error ?? 'Error', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.pets, size: 80, color: Colors.green),
                const SizedBox(height: 12),
                const Text('Vacunación Municipal',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _correo,
                  decoration: const InputDecoration(
                      labelText: 'Correo', prefixIcon: Icon(Icons.email)),
                  validator: (v) =>
                      v!.isEmpty ? 'Ingrese el correo' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pass,
                  obscureText: !_verPass,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_verPass
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() => _verPass = !_verPass),
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Ingrese la contraseña' : null,
                ),
                const SizedBox(height: 24),
                auth.cargando
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Ingresar'),
                      ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RecuperarPasswordScreen()),
                  ),
                  child: const Text('¿Olvidó su contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}