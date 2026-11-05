import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(20)),
            child: Text(
              'Hola, ${AuthService.usuario ?? 'invitado'} 👋',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cs.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.go('/posts'),
            icon: const Icon(Icons.article),
            label: const Text('Ver posts'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.go('/posts?search=qui'),
            icon: const Icon(Icons.search),
            label: const Text('Buscar posts que contengan "qui"'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.push('/posts/1'),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Abrir el post 1 directamente'),
          ),
        ],
      ),
    );
  }
}
