import 'package:flutter/material.dart';
import 'qr_screen.dart';
import 'asistencias_hoy_screen.dart';
import 'historial_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  @override
  Widget build(BuildContext context) {
    // La cámara solo se crea cuando estamos en la sección de escaneo
    final List<Widget> pantallas = [
      const QRScreen(),
      const AsistenciasHoyScreen(),
      const HistorialScreen(),
    ];

    return Scaffold(
      body: pantallas[_seccion],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Escanear'),
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Hoy'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }
}
