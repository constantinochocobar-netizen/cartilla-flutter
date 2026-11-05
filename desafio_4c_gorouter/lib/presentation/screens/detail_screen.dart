import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';

class DetailScreen extends StatefulWidget {
  final int postId; // viene de la URL: /posts/:id
  const DetailScreen({super.key, required this.postId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Post> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = ApiService().getPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El AppBar agrega el botón ← automáticamente porque llegamos con push
      appBar: AppBar(title: Text('Post ${widget.postId}')),
      body: FutureBuilder<Post>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final post = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(post.titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(post.cuerpo, style: const TextStyle(fontSize: 17)),
              const SizedBox(height: 24),
              // context.pop(): exactamente igual que Navigator.pop()
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Volver'),
              ),
            ],
          );
        },
      ),
    );
  }
}
