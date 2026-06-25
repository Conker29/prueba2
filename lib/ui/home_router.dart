import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/auth_provider.dart';
import '../core/constants.dart';
import 'cambiar_password_screen.dart';
import 'campana/dashboard_campana_screen.dart';
import 'brigada/dashboard_brigada_screen.dart';
import 'vacunador/sectores_screen.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario!;

    // Cambio obligatorio en primer login
    if (usuario.debeCambiarPassword) {
      return const CambiarPasswordScreen();
    }

    switch (usuario.rol) {
      case Roles.coordinadorCampana:
        return const DashboardCampanaScreen();
      case Roles.coordinadorBrigada:
        return const DashboardBrigadaScreen();
      case Roles.vacunador:
        return const SectoresScreen();
      default:
        return const Scaffold(body: Center(child: Text('Rol desconocido')));
    }
  }
}