// DESAFÍO 6 — Tareas con SQLite + Preferencias con Hive
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/screens/home_screen.dart';

// main.dart — inicializar Hive antes de runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('preferencias'); // abrir la 'caja' de datos
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder se reconstruye solo cuando la caja cambia:
    // así el modo oscuro se aplica a TODA la app al instante
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferencias').listenable(),
      builder: (context, box, _) {
        final bool oscuro = box.get('modoOscuro', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tareas locales',
          theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true, brightness: Brightness.light),
          darkTheme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true, brightness: Brightness.dark),
          themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
