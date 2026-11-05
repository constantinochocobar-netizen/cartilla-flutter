// DESAFÍO 3 — App con Drawer y Material 3
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp es StatefulWidget porque guarda el modo claro/oscuro de TODA la app
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modoOscuro = false;

  void _cambiarModo(bool valor) {
    setState(() => _modoOscuro = valor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drawer y Material 3',
      // Material 3 con colorSchemeSeed: genera toda la paleta desde un color
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(modoOscuro: _modoOscuro, onCambiarModo: _cambiarModo),
    );
  }
}

// ── Pantalla principal con NavigationBar y Drawer ─────────────────
class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final ValueChanged<bool> onCambiarModo;

  const HomeScreen({super.key, required this.modoOscuro, required this.onCambiarModo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0; // 0 = Inicio, 1 = Tareas, 2 = Perfil

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  final List<Widget> _pantallas = const [
    InicioScreen(),
    TareasScreen(),
    PerfilScreen(),
  ];

  void _abrirConfiguracion() {
    Navigator.pop(context); // IMPORTANTE: cerrar el drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfiguracionScreen(
          modoOscuro: widget.modoOscuro,
          onCambiarModo: widget.onCambiarModo,
        ),
      ),
    );
  }

  void _irASeccion(int indice) {
    Navigator.pop(context); // cerrar el drawer
    setState(() => _seccion = indice);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
      ),

      // ── Drawer completo ─────────────────────────────────────────
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
                  Text('Micael Chocobar',
                      style: TextStyle(color: cs.onPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('constantinochocobar@gmail.com',
                      style: TextStyle(color: cs.onPrimary, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _seccion == 0,
              selectedTileColor: cs.secondaryContainer,
              onTap: () => _irASeccion(0),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              selected: _seccion == 1,
              selectedTileColor: cs.secondaryContainer,
              onTap: () => _irASeccion(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 2,
              selectedTileColor: cs.secondaryContainer,
              onTap: () => _irASeccion(2),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: _abrirConfiguracion,
            ),
            const Divider(), // línea separadora
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: _pantallas[_seccion],

      // ── NavigationBar con 3 secciones ───────────────────────────
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

// ── Inicio: Column con banner decorado y Row con 3 estadísticas ──
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Container decorado como banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.wb_sunny, color: cs.onPrimary, size: 36),
              const SizedBox(height: 12),
              Text('¡Buen día, Micael!',
                  style: TextStyle(color: cs.onPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Tenés 3 tareas pendientes para hoy',
                  style: TextStyle(color: cs.onPrimary, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Row con 3 estadísticas
        Row(
          children: const [
            Expanded(child: Estadistica(icono: Icons.pending_actions, valor: '3', etiqueta: 'Pendientes')),
            SizedBox(width: 12),
            Expanded(child: Estadistica(icono: Icons.check_circle, valor: '12', etiqueta: 'Hechas')),
            SizedBox(width: 12),
            Expanded(child: Estadistica(icono: Icons.local_fire_department, valor: '5', etiqueta: 'Días seguidos')),
          ],
        ),
        const SizedBox(height: 20),

        Text('Próximas tareas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cs.onSurface)),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: Icon(Icons.school, color: cs.primary),
            title: const Text('Entregar Desafío 3'),
            subtitle: const Text('Hoy, 18:00'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.menu_book, color: cs.primary),
            title: const Text('Leer la Unidad 4'),
            subtitle: const Text('Mañana'),
          ),
        ),
      ],
    );
  }
}

// Componente reutilizable para cada estadística
class Estadistica extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;

  const Estadistica({super.key, required this.icono, required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icono, color: cs.onSecondaryContainer),
          const SizedBox(height: 6),
          Text(valor,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSecondaryContainer)),
          Text(etiqueta,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: cs.onSecondaryContainer)),
        ],
      ),
    );
  }
}

// ── Tareas: lista simple con FloatingActionButton (EXTRA) ────────
class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final List<String> tareas = ['Entregar Desafío 3', 'Leer la Unidad 4', 'Practicar Row y Column', 'Subir a GitHub'];

    return Scaffold(
      body: ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.primary,
              child: Text('${index + 1}', style: TextStyle(color: cs.onPrimary)),
            ),
            title: Text(tareas[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Tarea número ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Próximamente: agregar tareas')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Perfil ───────────────────────────────────────────────────────
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 56,
            backgroundImage: NetworkImage('https://picsum.photos/id/64/300/300'),
          ),
          const SizedBox(height: 16),
          Text('Micael Chocobar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cs.onSurface)),
          Text('Técnico en Informática', style: TextStyle(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── Configuración: Switch que cambia entre modo claro y oscuro ───
class ConfiguracionScreen extends StatefulWidget {
  final bool modoOscuro;
  final ValueChanged<bool> onCambiarModo;

  const ConfiguracionScreen({super.key, required this.modoOscuro, required this.onCambiarModo});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  late bool _modoOscuro;

  @override
  void initState() {
    super.initState();
    _modoOscuro = widget.modoOscuro;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambia el tema de la app'),
            secondary: const Icon(Icons.dark_mode),
            value: _modoOscuro,
            onChanged: (bool nuevoValor) {
              setState(() => _modoOscuro = nuevoValor);
              widget.onCambiarModo(nuevoValor); // avisa a MyApp para cambiar el tema
            },
          ),
        ],
      ),
    );
  }
}
