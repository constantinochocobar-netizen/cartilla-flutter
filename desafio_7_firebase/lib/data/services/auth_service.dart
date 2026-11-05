// data/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ── REGISTRAR usuario nuevo ────────────────────────────────
  // Devuelve null si fue exitoso, o un mensaje de error
  Future<String?> registrar(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // null = sin error = exitoso
    } on FirebaseAuthException catch (e) {
      // Traducir los códigos de error de Firebase a mensajes amigables
      switch (e.code) {
        case 'weak-password':
          return 'La contraseña debe tener al menos 6 caracteres.';
        case 'email-already-in-use':
          return 'Este email ya está registrado.';
        case 'invalid-email':
          return 'El formato del email no es válido.';
        default:
          return 'Error al registrarse: ${e.message}';
      }
    }
  }

  // ── INICIAR SESIÓN ─────────────────────────────────────────
  Future<String?> iniciarSesion(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // sin error
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este email.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'invalid-credential':
          return 'Email o contraseña incorrectos.';
        case 'invalid-email':
          return 'El formato del email no es válido.';
        case 'user-disabled':
          return 'Esta cuenta fue deshabilitada.';
        default:
          return 'Error al iniciar sesión.';
      }
    }
  }

  // ── CERRAR SESIÓN ──────────────────────────────────────────
  Future<void> cerrarSesion() async => await auth.signOut();
}
