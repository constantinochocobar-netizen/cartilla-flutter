// data/services/api_service.dart

import 'dart:convert'; // para jsonDecode
import 'package:http/http.dart' as http;
import '../../domain/entities/post.dart';

class ApiService {
  // La URL base de la API — guardarla como constante es buena práctica
  static const String _base = 'https://jsonplaceholder.typicode.com';

  // ── GET /posts — traer todos los posts ──────────────────────
  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$_base/posts'));

      // 200 = OK, 404 = no encontrado, 500 = error del servidor
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      // Si no hay internet o la URL está mal, llegamos acá
      throw Exception('Error de conexión: $e');
    }
  }
}
