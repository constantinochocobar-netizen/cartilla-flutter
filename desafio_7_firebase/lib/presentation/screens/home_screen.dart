import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import 'tareas_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<Widget> _pantallas = const [TareasScreen(), PerfilScreen()];

  Future<void> _cerrarSesion() async {
    Navigator.pop(context);
    await AuthService().cerrarSesion();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(_seccion == 0 ? 'Mis tareas' : 'Perfil')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: cs.onPrimary,
                    child: Icon(Icons.person, size: 32, color: cs.primary),
                  ),
                  const SizedBox(height: 10),
                  Text(email, style: TextStyle(color: cs.onPrimary, fontSize: 15)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis tareas'),
              selected: _seccion == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() => _seccion = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() => _seccion = 1);
              },
            ),
            const Divider(),
            // Avance: cerrar sesión desde el Drawer te devuelve al login
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),
      body: _pantallas[_seccion],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.task_outlined), selectedIcon: Icon(Icons.task_alt), label: 'Tareas'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
