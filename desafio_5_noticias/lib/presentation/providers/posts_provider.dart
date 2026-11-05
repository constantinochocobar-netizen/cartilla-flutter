import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super(const []);

  void guardar(List<Post> posts) {
    state = posts;
  }

  void limpiar() {
    state = const [];
  }
}

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>(
  (ref) => PostsNotifier(),
);
