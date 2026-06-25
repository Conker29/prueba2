import 'package:flutter/material.dart';

class CargandoWidget extends StatelessWidget {
  const CargandoWidget({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ErrorWidget2 extends StatelessWidget {
  final String mensaje;
  const ErrorWidget2(this.mensaje, {super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('⚠️ $mensaje', textAlign: TextAlign.center),
        ),
      );
}

void mostrarSnack(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: error ? Colors.red : Colors.green,
  ));
}