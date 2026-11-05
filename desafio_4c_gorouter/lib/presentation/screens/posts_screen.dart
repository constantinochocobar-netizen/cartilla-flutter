import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';

class PostsScreen extends StatefulWidget {
  final String busqueda;
  const PostsScreen({super.key, this.busqueda = ''});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ApiService _api = ApiService();
  late Future<List<Post>> _postsFuture;
  final TextEditingController _buscarCtrl = TextEditingController();

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
    final filtro = widget.busqueda;

    return Scaffold(
      appBar: AppBar(title: Text(filtro.isEmpty ? 'Posts' : 'Posts: "${widget.busqueda}"')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            // Avance: el extra, la búsqueda queda en la URL /posts?search=...
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscarCtrl,
                    decoration: InputDecoration(
                      labelText: 'Buscar por título',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => context.go('/posts?search=${_buscarCtrl.text.trim()}'),
                ),
              ],
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
                final posts = snapshot.data!.where((p) => p.titulo.contains(filtro)).toList();
                if (posts.isEmpty) return const Center(child: Text('Sin resultados'));
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    final post = posts[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(post.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(post.cuerpo, maxLines: 1, overflow: TextOverflow.ellipsis),
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
