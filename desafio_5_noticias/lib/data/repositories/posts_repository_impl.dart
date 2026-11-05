// data/repositories/posts_repository_impl.dart
// Implementación concreta del contrato: usa el ApiService para traer los datos.

import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../services/api_service.dart';

class PostsRepositoryImpl implements PostsRepository {
  final ApiService _api = ApiService();

  @override
  Future<List<Post>> getPosts() => _api.getPosts();
}
