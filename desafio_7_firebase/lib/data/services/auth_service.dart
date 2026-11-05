import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> registrar(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
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

  Future<String?> iniciarSesion(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este email.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'user-disabled':
          return 'Esta cuenta fue deshabilitada.';
        default:
          return 'Error al iniciar sesión.';
      }
    }
  }

  Future<void> cerrarSesion() async => await auth.signOut();
}
