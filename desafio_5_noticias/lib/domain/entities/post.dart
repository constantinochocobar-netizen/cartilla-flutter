// domain/entities/post.dart
// Clase de datos pura: representa un post de la API.

class Post {
  final int id;
  final String titulo;
  final String cuerpo;
  final int usuarioId;

  Post({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.usuarioId,
  });

  // fromJson: convierte el mapa JSON en un objeto Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'], // la clave 'id' del JSON
      titulo: json['title'], // Dart: titulo → JSON: title
      cuerpo: json['body'], // Dart: cuerpo → JSON: body
      usuarioId: json['userId'],
    );
  }

  // toJson: para enviar datos a la API (POST/PUT)
  Map<String, dynamic> toJson() => {
        'title': titulo,
        'body': cuerpo,
        'userId': usuarioId,
      };
}
