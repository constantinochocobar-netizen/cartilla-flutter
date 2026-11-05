import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('preferencias');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Avance: el modo oscuro se aplica a toda la app con ThemeMode
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
