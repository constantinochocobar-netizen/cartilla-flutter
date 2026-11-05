class Alumno {
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas;

  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  // Avance: ya saca el promedio de las 3 notas
  double calcularPromedio() {
    double suma = notas.reduce((a, b) => a + b);
    return suma / notas.length;
  }

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

  @override
  String toString() {
    return '$nombre $apellido ($edad años) — Promedio: ${calcularPromedio()} — ${estadoFinal()}';
  }
}

void main() {
  List<Alumno> alumnos = [
    Alumno(nombre: 'Sofía', apellido: 'Gómez', edad: 17, notas: [8.0, 9.0, 7.0]),
    Alumno(nombre: 'Lucas', apellido: 'Pérez', edad: 16, notas: [4.0, 5.0, 3.0]),
    Alumno(nombre: 'Ana', apellido: 'Martínez', edad: 18, notas: [2.0, 3.0, 4.0]),
    Alumno(nombre: 'Tomás', apellido: 'Rodríguez', edad: 17, notas: [10.0, 9.0, 8.0]),
    Alumno(nombre: 'Valentina', apellido: 'López', edad: 16, notas: [6.0, 7.0, 5.0]),
  ];

  print('===== ESTADO DE CADA ALUMNO =====');
  for (Alumno alumno in alumnos) {
    print(alumno);
  }

  // Avance: ahora busca al que tiene el mejor promedio
  Alumno mejor = alumnos[0];
  for (Alumno alumno in alumnos) {
    if (alumno.calcularPromedio() > mejor.calcularPromedio()) {
      mejor = alumno;
    }
  }
  print('');
  print('===== MEJOR PROMEDIO =====');
  print('${mejor.nombre} ${mejor.apellido} con ${mejor.calcularPromedio()}');

  int aprobados = alumnos.where((a) => a.estadoFinal() == 'Aprobado').length;
  int recuperatorio = alumnos.where((a) => a.estadoFinal() == 'Recuperatorio').length;
  int desaprobados = alumnos.where((a) => a.estadoFinal() == 'Desaprobado').length;
  print('');
  print('===== RESUMEN =====');
  print('Aprobados: $aprobados');
  print('Recuperatorio: $recuperatorio');
  print('Desaprobados: $desaprobados');
  print('No aprobados (recuperatorio + desaprobados): ${recuperatorio + desaprobados}');

  // Avance: el extra, la lista ordenada de mayor a menor
  alumnos.sort((a, b) => b.calcularPromedio().compareTo(a.calcularPromedio()));
  print('');
  print('===== RANKING (mayor a menor) =====');
  for (int i = 0; i < alumnos.length; i++) {
    print('${i + 1}. ${alumnos[i]}');
  }
}
