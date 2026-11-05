// data/services/tareas_service.dart
// CRUD de tareas en Cloud Firestore, separado por usuario.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TareasService {
  final db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // ── CREATE: agregar un documento nuevo (incluye el userId) ─
  Future<void> agregarTarea(String titulo) async {
    await db.collection('tareas').add({
      'titulo': titulo,
      'completada': false,
      'prioridad': 'normal',
      // serverTimestamp usa el reloj del servidor (más confiable)
      'fechaCreacion': FieldValue.serverTimestamp(),
      // Guardar el ID del usuario para filtrar sus propias tareas
      'userId': _uid,
    });
  }

  // ── READ en tiempo real: solo las tareas del usuario actual ─
  Stream<QuerySnapshot> tareasDelUsuario() {
    return db
        .collection('tareas')
        .where('userId', isEqualTo: _uid)
        .orderBy('fechaCreacion', descending: true)
        .snapshots(); // .snapshots() devuelve un Stream
  }

  // ── UPDATE: actualizar campos de un documento ──────────────
  Future<void> actualizarTarea(String docId, bool completada) async {
    await db.collection('tareas').doc(docId).update({
      'completada': completada,
      'fechaCompletado': completada ? FieldValue.serverTimestamp() : null,
    });
  }

  // ── DELETE: eliminar un documento ──────────────────────────
  Future<void> eliminarTarea(String docId) async {
    await db.collection('tareas').doc(docId).delete();
  }
}
