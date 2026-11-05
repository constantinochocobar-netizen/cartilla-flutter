import 'package:flutter/material.dart';
import 'inicio_screen.dart';
import 'tareas_screen.dart';
import 'perfil_screen.dart';

// HomeScreen: NavigationBar con 3 secciones + Drawer
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  final List<Widget> _pantallas = const [
    InicioScreen(),
    TareasScreen(),
    PerfilScreen(),
  ];

  void _irA(int indice) {
    Navigator.pop(context); // cerrar el drawer
    setState(() => _seccion = indice);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_seccion])),

      // ── Drawer con foto de perfil, nombre y 4 ítems ──────────────
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://picsum.photos/id/64/200/200'),
                  ),
                  const SizedBox(height: 10),
                  Text('Micael Chocobar', style: TextStyle(color: cs.onPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('constantinochocobar@gmail.com', style: TextStyle(color: cs.onPrimary, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _seccion == 0,
              onTap: () => _irA(0),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              selected: _seccion == 1,
              onTap: () => _irA(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 2,
              onTap: () => _irA(2),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tareas con Riverpod — Desafío 4 de la Cartilla de Flutter')),
                );
              },
            ),
          ],
        ),
      ),

      body: _pantallas[_seccion],

      // ── NavigationBar: Inicio, Tareas, Perfil ────────────────────
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int indice) {
          setState(() => _seccion = indice);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
