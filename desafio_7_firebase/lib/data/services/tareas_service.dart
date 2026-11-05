import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TareasService {
  final db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> agregarTarea(String titulo) async {
    await db.collection('tareas').add({
      'titulo': titulo,
      'completada': false,
      'prioridad': 'normal',
      'fechaCreacion': FieldValue.serverTimestamp(),
      'userId': _uid, // Avance: cada tarea queda guardada con el usuario que la creó
    });
  }

  Stream<QuerySnapshot> tareasDelUsuario() {
    return db
        .collection('tareas')
        .where('userId', isEqualTo: _uid)
        .orderBy('fechaCreacion', descending: true)
        .snapshots();
  }

  Future<void> actualizarTarea(String docId, bool completada) async {
    await db.collection('tareas').doc(docId).update({
      'completada': completada,
      'fechaCompletado': completada ? FieldValue.serverTimestamp() : null,
    });
  }

  Future<void> eliminarTarea(String docId) async {
    await db.collection('tareas').doc(docId).delete();
  }
}
