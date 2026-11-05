import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';
import '../providers/posts_provider.dart';
import 'detalle_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ApiService _apiService = ApiService();

  late Future<List<Post>> _postsFuture;

  bool _buscando = false;
  String _filtro = '';
  final TextEditingController _buscarCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postsFuture = _cargarPosts();
  }

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  // Avance: el extra, si los posts ya están en Riverpod no vuelve a llamar a la API
  Future<List<Post>> _cargarPosts() async {
    final guardados = ref.read(postsProvider);
    if (guardados.isNotEmpty) return guardados;

    final posts = await _apiService.getPosts();
    ref.read(postsProvider.notifier).guardar(posts);
    return posts;
  }

  void _reintentar() {
    ref.read(postsProvider.notifier).limpiar();
    setState(() {
      _postsFuture = _cargarPosts();
    });
  }

  void _cerrarBuscador() {
    setState(() {
      _buscando = false;
      _filtro = '';
      _buscarCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guardados = ref.watch(postsProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                controller: _buscarCtrl,
                decoration: const InputDecoration(hintText: 'Buscar por título'),
              )
            : Text('Noticias ($guardados)'),
        // Avance: ya anda el buscador del AppBar, filtra por título
        actions: [
          if (_buscando)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => setState(() => _filtro = _buscarCtrl.text.trim()),
            ),
          IconButton(
            icon: Icon(_buscando ? Icons.close : Icons.search),
            onPressed: () {
              if (_buscando) {
                _cerrarBuscador();
              } else {
                setState(() => _buscando = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reintentar,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando posts...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    const Text('Error al cargar los datos'),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _reintentar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Post> todos = snapshot.data!;
          final List<Post> posts = todos.where((p) => p.titulo.contains(_filtro)).toList();

          if (posts.isEmpty) {
            return Center(child: Text('No hay posts que contengan "$_filtro"'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(post.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  post.cuerpo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleScreen(post: post),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
