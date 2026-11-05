// presentation/providers/posts_provider.dart
// EXTRA: Provider de Riverpod que guarda los posts ya cargados.
// Así, si volvés a la pantalla, no se vuelve a llamar a la API.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super(const []);

  // Guardar la lista que llegó de la API
  void guardar(List<Post> posts) {
    state = posts;
  }

  // Vaciar la caché (por ejemplo, para forzar una recarga)
  void limpiar() {
    state = const [];
  }
}

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>(
  (ref) => PostsNotifier(),
);
