import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';

class PostsScreen extends StatefulWidget {
  final String busqueda; // viene de la URL: /posts?search=...
  const PostsScreen({super.key, this.busqueda = ''});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ApiService _api = ApiService();
  late Future<List<Post>> _postsFuture;
  late final TextEditingController _buscarCtrl = TextEditingController(text: widget.busqueda);

  @override
  void initState() {
    super.initState();
    _postsFuture = _api.getPosts();
  }

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtro = widget.busqueda.toLowerCase();

    return Scaffold(
      appBar: AppBar(title: Text(filtro.isEmpty ? 'Posts' : 'Posts: "${widget.busqueda}"')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscarCtrl,
              decoration: InputDecoration(
                labelText: 'Buscar por título',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // Al buscar, la búsqueda queda en la URL: /posts?search=texto
              onSubmitted: (texto) => context.go(
                texto.trim().isEmpty ? '/posts' : '/posts?search=${Uri.encodeQueryComponent(texto.trim())}',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final posts = snapshot.data!.where((p) => p.titulo.toLowerCase().contains(filtro)).toList();
                if (posts.isEmpty) return const Center(child: Text('Sin resultados'));
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    final post = posts[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(post.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(post.cuerpo, maxLines: 1, overflow: TextOverflow.ellipsis),
                      // context.push(): apila el detalle, se puede volver
                      onTap: () => context.push('/posts/${post.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
