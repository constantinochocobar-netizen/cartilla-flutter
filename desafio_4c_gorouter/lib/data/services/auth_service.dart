// data/services/auth_service.dart
// Sesión simulada (todavía no usamos Firebase, eso es la Unidad 7).
// Guarda en memoria el nombre del usuario que inició sesión.

class AuthService {
  static String? usuario; // null = no hay sesión

  static bool get estaLogueado => usuario != null;

  static String? iniciarSesion(String email, String password) {
    if (!email.contains('@')) return 'El formato del email no es válido.';
    if (password.length < 6) return 'La contraseña debe tener al menos 6 caracteres.';
    usuario = email.trim();
    return null; // null = sin error
  }

  static void cerrarSesion() {
    usuario = null;
  }
}
