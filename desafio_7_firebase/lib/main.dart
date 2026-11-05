// DESAFÍO 7 — App completa con Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // generado automáticamente por flutterfire configure
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  // Necesario siempre que uses operaciones async antes de runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase — esto DEBE ir antes de runApp()
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareas en la nube',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      // EXTRA: detectar si hay sesión activa al abrir la app.
      // authStateChanges() emite un evento cada vez que el usuario
      // inicia o cierra sesión, y la pantalla cambia sola.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          // Si hay un usuario logueado, mostrar la pantalla principal
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          }
          // Si no hay sesión activa, mostrar login
          return const LoginScreen();
        },
      ),
    );
  }
}
