// data/services/asistencia_service.dart
// Guarda y lee las asistencias en Cloud Firestore.

import 'package:cloud_firestore/cloud_firestore.dart';

class AsistenciaService {
  final db = FirebaseFirestore.instance;

  // Fecha de hoy como texto 'AAAA-MM-DD' (ej: 2026-11-05)
  static String fechaDe(DateTime d) => d.toIso8601String().substring(0, 10);
  // Hora como texto 'HH:MM:SS'
  static String horaDe(DateTime d) => d.toIso8601String().substring(11, 19);

  static String get hoy => fechaDe(DateTime.now());

  // ¿El alumno ya fue registrado hoy?
  Future<bool> yaRegistradoHoy(String nombre) async {
    final resultado = await db
        .collection('asistencias')
        .where('fecha', isEqualTo: hoy)
        .where('nombre', isEqualTo: nombre)
        .get();
    return resultado.docs.isNotEmpty;
  }

  // Guardar: nombre del alumno, fecha actual y hora actual
  Future<void> registrar(String nombre) async {
    final ahora = DateTime.now();
    await db.collection('asistencias').add({
      'nombre': nombre,
      'fecha': fechaDe(ahora),
      'hora': horaDe(ahora),
      'creado': FieldValue.serverTimestamp(),
    });
  }

  // Asistencias de hoy, en tiempo real
  Stream<QuerySnapshot> asistenciasDeHoy() {
    return db.collection('asistencias').where('fecha', isEqualTo: hoy).snapshots();
  }

  // Todas las asistencias (para el historial), de la fecha más nueva a la más vieja
  Stream<QuerySnapshot> historial() {
    return db.collection('asistencias').orderBy('fecha', descending: true).snapshots();
  }

  // Eliminar los registros del día actual
  Future<int> limpiarHoy() async {
    final resultado = await db.collection('asistencias').where('fecha', isEqualTo: hoy).get();
    for (final doc in resultado.docs) {
      await doc.reference.delete();
    }
    return resultado.docs.length;
  }
}
