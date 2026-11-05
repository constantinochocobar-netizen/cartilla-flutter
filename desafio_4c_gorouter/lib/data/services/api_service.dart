import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/post.dart';

class ApiService {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$_base/posts'));
    if (response.statusCode != 200) {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
    final List<dynamic> lista = jsonDecode(response.body);
    return lista.map((item) => Post.fromJson(item)).toList();
  }

  Future<Post> getPost(int id) async {
    final response = await http.get(Uri.parse('$_base/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
    return Post.fromJson(jsonDecode(response.body));
  }
}
