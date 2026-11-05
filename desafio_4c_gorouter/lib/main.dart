// DESAFÍO 4C — Migrar a GoRouter
import 'package:flutter/material.dart';
import 'presentation/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router() en lugar de MaterialApp()
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mi App Flutter',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      // routerConfig: el GoRouter que definimos en router.dart
      routerConfig: appRouter,
      // Ya no hay 'home:' — GoRouter maneja la pantalla inicial
    );
  }
}
