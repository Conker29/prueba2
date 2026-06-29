import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/usuario_provider.dart';
import 'providers/sector_provider.dart';
import 'providers/vacunacion_provider.dart';
import 'providers/sync_provider.dart';
import 'ui/login_screen.dart';
import 'ui/home_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => SectorProvider()),
        ChangeNotifierProvider(create: (_) => VacunacionProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
      ],
      child: MaterialApp(
        title: 'Vacunación Municipal',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decide si mostrar Login o Home según sesión activa
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.cargando) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (auth.usuario == null) {
          return const LoginScreen();
        }
        return const HomeRouter();
      },
    );
  }
}