class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final String prioridad;
  final String fecha;

  Tarea({
    this.id,
    required this.titulo,
    this.descripcion = '',
    this.completada = false,
    this.prioridad = 'normal',
    required this.fecha,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'completada': completada ? 1 : 0,
        'prioridad': prioridad,
        'fecha': fecha,
      };

  factory Tarea.fromMap(Map<String, dynamic> map) => Tarea(
        id: map['id'],
        titulo: map['titulo'],
        descripcion: map['descripcion'] ?? '',
        completada: map['completada'] == 1,
        prioridad: map['prioridad'],
        fecha: map['fecha'],
      );

  Tarea copyWith({bool? completada, String? titulo}) => Tarea(
        id: id,
        titulo: titulo ?? this.titulo,
        descripcion: descripcion,
        completada: completada ?? this.completada,
        prioridad: prioridad,
        fecha: fecha,
      );
}
