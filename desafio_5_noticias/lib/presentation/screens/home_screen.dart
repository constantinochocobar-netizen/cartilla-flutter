// presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../providers/posts_provider.dart';
import 'detalle_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // La UI solo conoce el contrato (dominio), no la API
  final PostsRepository _repo = PostsRepositoryImpl();

  // Guardamos el Future para no re-llamar la API en cada build
  late Future<List<Post>> _postsFuture;

  // Buscador del AppBar
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

  // Si los posts ya están guardados en Riverpod, los usa.
  // Si no, los pide a la API y los guarda.
  Future<List<Post>> _cargarPosts() async {
    final guardados = ref.read(postsProvider);
    if (guardados.isNotEmpty) return guardados;

    final posts = await _repo.getPosts();
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
        // Buscador en el AppBar: cambia el título por un TextField
        title: _buscando
            ? TextField(
                controller: _buscarCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar por título...',
                  border: InputBorder.none,
                ),
                onChanged: (texto) => setState(() => _filtro = texto.trim().toLowerCase()),
              )
            : Text('Noticias ($guardados)'),
        actions: [
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
          // ── ESTADO 1: Todavía cargando ─────────────────────
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

          // ── ESTADO 2: Hubo un error ────────────────────────
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

          // ── ESTADO 3: Datos llegaron ───────────────────────
          final List<Post> todos = snapshot.data!;
          final List<Post> posts = todos.where((p) => p.titulo.toLowerCase().contains(_filtro)).toList();

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
                // Al tocar, navegar a DetalleScreen pasando el objeto Post
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
