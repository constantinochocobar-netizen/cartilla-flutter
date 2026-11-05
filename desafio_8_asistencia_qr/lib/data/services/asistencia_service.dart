import 'package:cloud_firestore/cloud_firestore.dart';

class AsistenciaService {
  final db = FirebaseFirestore.instance;

  static String fechaDe(DateTime d) => '${d.day}/${d.month}/${d.year}';
  static String horaDe(DateTime d) => '${d.hour}:${d.minute}:${d.second}';

  static String get hoy => fechaDe(DateTime.now());

  // Avance: antes de guardar se fija si el alumno ya estaba hoy
  Future<bool> yaRegistradoHoy(String nombre) async {
    final resultado = await db
        .collection('asistencias')
        .where('fecha', isEqualTo: hoy)
        .where('nombre', isEqualTo: nombre)
        .get();
    return resultado.docs.isNotEmpty;
  }

  Future<void> registrar(String nombre) async {
    final ahora = DateTime.now();
    await db.collection('asistencias').add({
      'nombre': nombre,
      'fecha': fechaDe(ahora),
      'hora': horaDe(ahora),
      'creado': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> asistenciasDeHoy() {
    return db.collection('asistencias').where('fecha', isEqualTo: hoy).snapshots();
  }

  Stream<QuerySnapshot> historial() {
    return db.collection('asistencias').orderBy('creado', descending: true).snapshots();
  }

  Future<int> limpiarHoy() async {
    final resultado = await db.collection('asistencias').where('fecha', isEqualTo: hoy).get();
    for (var doc in resultado.docs) {
      await db.collection('asistencias').doc(doc.id).delete();
    }
    return resultado.docs.length;
  }
}
