import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:vacunacion_app/providers/auth_provider.dart';
import 'package:vacunacion_app/providers/sector_provider.dart';
import 'package:vacunacion_app/ui/login_screen.dart';
import 'package:vacunacion_app/core/theme.dart';

void main() {
  testWidgets('LoginScreen muestra campos de correo y contraseña',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => SectorProvider()),
        ],
        child: MaterialApp(
          theme: appTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Vacunación Municipal'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Correo'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('¿Olvidó su contraseña?'), findsOneWidget);
  });

  testWidgets('LoginScreen valida campos vacíos al intentar ingresar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => SectorProvider()),
        ],
        child: MaterialApp(
          theme: appTheme,
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Ingrese el correo'), findsOneWidget);
    expect(find.text('Ingrese la contraseña'), findsOneWidget);
  });
}
