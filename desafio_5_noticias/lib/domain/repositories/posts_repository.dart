// domain/repositories/posts_repository.dart
// Interfaz abstracta (contrato): dice QUÉ se puede hacer, no CÓMO.
// La UI depende de este contrato y no de la API directamente.

import '../entities/post.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts();
}
