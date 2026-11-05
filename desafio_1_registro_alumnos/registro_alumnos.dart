// DESAFÍO 1 — Registro de alumnos
// Practicar clases, listas y funciones en Dart puro (sin Flutter todavía).
// Se puede correr con: dart run registro_alumnos.dart  (o pegarlo en dartpad.dev)

// ── 1. La clase Alumno ─────────────────────────────────────────
class Alumno {
  // Propiedades — qué tiene un Alumno
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas; // las 3 notas del alumno

  // Constructor con parámetros nombrados
  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  // ── 2. calcularPromedio(): promedio de las 3 notas ───────────
  double calcularPromedio() {
    double suma = notas.reduce((a, b) => a + b);
    return suma / notas.length;
  }

  // ── 3. estadoFinal(): Aprobado, Recuperatorio o Desaprobado ──
  String estadoFinal() {
    double promedio = calcularPromedio();
    if (promedio >= 6) {
      return 'Aprobado';
    } else if (promedio >= 4) {
      return 'Recuperatorio';
    } else {
      return 'Desaprobado';
    }
  }

  // ── 4. toString(): nombre completo y estado ──────────────────
  @override
  String toString() {
    return '$nombre $apellido ($edad años) — Promedio: ${calcularPromedio().toStringAsFixed(2)} — ${estadoFinal()}';
  }
}

void main() {
  // ── 5. Lista de 5 alumnos distintos ──────────────────────────
  List<Alumno> alumnos = [
    Alumno(nombre: 'Sofía', apellido: 'Gómez', edad: 17, notas: [8.5, 9.0, 7.5]),
    Alumno(nombre: 'Lucas', apellido: 'Pérez', edad: 16, notas: [4.0, 5.0, 3.5]),
    Alumno(nombre: 'Ana', apellido: 'Martínez', edad: 18, notas: [2.0, 3.0, 4.0]),
    Alumno(nombre: 'Tomás', apellido: 'Rodríguez', edad: 17, notas: [10.0, 9.5, 9.0]),
    Alumno(nombre: 'Valentina', apellido: 'López', edad: 16, notas: [6.0, 6.5, 5.5]),
  ];

  print('===== ESTADO DE CADA ALUMNO =====');
  for (Alumno alumno in alumnos) {
    print(alumno);
  }

  // ── 6. Alumno con el promedio más alto ───────────────────────
  Alumno mejor = alumnos[0];
  for (Alumno alumno in alumnos) {
    if (alumno.calcularPromedio() > mejor.calcularPromedio()) {
      mejor = alumno;
    }
  }
  print('');
  print('===== MEJOR PROMEDIO =====');
  print('${mejor.nombre} ${mejor.apellido} con ${mejor.calcularPromedio().toStringAsFixed(2)}');

  // ── 7. Contar aprobados y desaprobados ───────────────────────
  int aprobados = alumnos.where((a) => a.estadoFinal() == 'Aprobado').length;
  int recuperatorio = alumnos.where((a) => a.estadoFinal() == 'Recuperatorio').length;
  int desaprobados = alumnos.where((a) => a.estadoFinal() == 'Desaprobado').length;
  print('');
  print('===== RESUMEN =====');
  print('Aprobados: $aprobados');
  print('Recuperatorio: $recuperatorio');
  print('Desaprobados: $desaprobados');
  print('No aprobados (recuperatorio + desaprobados): ${recuperatorio + desaprobados}');

  // ── 8. EXTRA: ordenar por promedio de mayor a menor ──────────
  alumnos.sort((a, b) => b.calcularPromedio().compareTo(a.calcularPromedio()));
  print('');
  print('===== RANKING (mayor a menor) =====');
  for (int i = 0; i < alumnos.length; i++) {
    print('${i + 1}. ${alumnos[i]}');
  }
}
