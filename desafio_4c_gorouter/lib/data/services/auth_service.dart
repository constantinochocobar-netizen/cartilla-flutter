class AuthService {
  static String? usuario;

  static bool get estaLogueado => usuario != null;

  static String? iniciarSesion(String email, String password) {
    if (!email.contains('@')) return 'El formato del email no es válido.';
    if (password.length < 6) return 'La contraseña debe tener al menos 6 caracteres.';
    usuario = email.trim();
    return null;
  }

  static void cerrarSesion() {
    usuario = null;
  }
}
