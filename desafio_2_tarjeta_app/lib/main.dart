import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarjeta personal',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const TarjetaScreen(),
    );
  }
}

class TarjetaScreen extends StatefulWidget {
  const TarjetaScreen({super.key});

  @override
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {
  // Avance: con esta variable el Switch cambia el fondo
  bool _fondoColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoColor ? Colors.purple.shade100 : Colors.white,
      appBar: AppBar(
        title: const Text('Mi tarjeta'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage('https://picsum.photos/id/64/300/300'),
              ),
              const SizedBox(height: 20),

              const Text(
                'Micael Constantino Chocobar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Técnico en Informática — Desarrollador Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              SwitchListTile(
                title: const Text('Fondo de color'),
                subtitle: const Text('Cambia el color de fondo de la pantalla'),
                value: _fondoColor,
                activeColor: Colors.purple,
                onChanged: (bool nuevoValor) {
                  setState(() {
                    _fondoColor = nuevoValor;
                  });
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Hola!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.waving_hand),
                label: const Text('Saludar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
