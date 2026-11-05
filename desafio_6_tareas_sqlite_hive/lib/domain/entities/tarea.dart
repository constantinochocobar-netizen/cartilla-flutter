// domain/entities/tarea.dart

class Tarea {
  final int? id; // null hasta que la BD lo asigna automáticamente
  final String titulo;
  final String descripcion;
  final bool completada;
  final String prioridad; // 'alta', 'normal', 'baja'
  final String fecha;

  Tarea({
    this.id,
    required this.titulo,
    this.descripcion = '',
    this.completada = false,
    this.prioridad = 'normal',
    required this.fecha,
  });

  // Dart → SQLite (bool no existe en SQLite: true = 1, false = 0)
  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'completada': completada ? 1 : 0,
        'prioridad': prioridad,
        'fecha': fecha,
      };

  // SQLite → Dart
  factory Tarea.fromMap(Map<String, dynamic> map) => Tarea(
        id: map['id'],
        titulo: map['titulo'],
        descripcion: map['descripcion'] ?? '',
        completada: map['completada'] == 1, // 1 = true, 0 = false
        prioridad: map['prioridad'],
        fecha: map['fecha'],
      );

  // copyWith: crear una copia con algunos campos modificados
  Tarea copyWith({bool? completada, String? titulo}) => Tarea(
        id: id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion,
        completada: completada ?? this.completada,
        prioridad: prioridad,
        fecha: fecha,
      );
}
