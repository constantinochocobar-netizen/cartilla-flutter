import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class DetalleScreen extends StatelessWidget {
  final Post post;

  const DetalleScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Post #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            post.titulo,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cs.primary),
          ),
          const SizedBox(height: 8),
          Text('Autor: usuario ${post.usuarioId}', style: const TextStyle(color: Colors.grey)),
          const Divider(height: 32),
          Text(post.cuerpo, style: const TextStyle(fontSize: 18, height: 1.5)),
        ],
      ),
    );
  }
}
