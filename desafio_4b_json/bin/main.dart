// DESAFÍO 4B — JSON desde cero
// Se puede pegar en dartpad.dev o correr con: dart run
//
// Respuesta de jsonplaceholder.typicode.com/users/1 (resumida):
// {
//   "id": 1,                         → Number  → int
//   "name": "Leanne Graham",         → String  → String
//   "username": "Bret",              → String  → String
//   "email": "Sincere@april.biz",    → String  → String
//   "address": {                     → Object  → Map<String, dynamic> → clase Address
//     "street": "Kulas Light",
//     "city": "Gwenborough",
//     "zipcode": "92998-3874",
//     "geo": { "lat": "-37.3159", "lng": "81.1496" }
//   },
//   "phone": "1-770-736-8031 x56442",
//   "website": "hildegard.org",
//   "company": { ... }
// }

import 'dart:convert'; // para jsonDecode
import 'package:http/http.dart' as http;

// ── EXTRA: clase para el objeto anidado 'address' ─────────────────
class Address {
  final String city;
  final String zipcode;

  Address({required this.city, required this.zipcode});

  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(city: json['city'], zipcode: json['zipcode']);

  @override
  String toString() => '$city ($zipcode)';
}

// ── La clase User ────────────────────────────────────────────────
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address; // objeto anidado

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
  });

  // factory constructor fromJson: convierte el Map en un User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      // Para el objeto anidado: llamar fromJson de Address
      address: Address.fromJson(json['address']),
    );
  }

  @override
  String toString() => '#$id $name (@$username) — $email — vive en $address';
}

// JSON de ejemplo (texto), igual al de la API, para probar sin internet
const String jsonUnUsuario = '''
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "city": "Gwenborough",
    "zipcode": "92998-3874"
  }
}
''';

void main() async {
  // ── Paso 1: el JSON llega como texto plano (String) ──────────────
  print('===== 1) Un usuario desde un JSON de ejemplo =====');

  // ── Paso 2: jsonDecode convierte el texto en un Map ──────────────
  final Map<String, dynamic> mapa = jsonDecode(jsonUnUsuario);
  print('El JSON empieza con { → es un OBJETO → Map. Nombre en el mapa: ${mapa['name']}');

  // ── Paso 3: fromJson convierte el Map en un objeto User ──────────
  final User usuario = User.fromJson(mapa);
  print(usuario);

  // ── Ahora con la API real ────────────────────────────────────────
  try {
    print('');
    print('===== 2) GET /users/1 (un objeto) =====');
    final respuesta1 = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));
    final User u1 = User.fromJson(jsonDecode(respuesta1.body));
    print(u1);

    print('');
    print('===== 3) GET /users (un ARRAY: empieza con [) =====');
    final respuesta = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    print('Primer caracter de la respuesta: "${respuesta.body.trim()[0]}" → es una lista');

    // jsonDecode devuelve una List<dynamic> porque el JSON empieza con [
    final List<dynamic> lista = jsonDecode(respuesta.body);
    // Por cada elemento de la lista, crear un User
    final List<User> usuarios = lista.map((item) => User.fromJson(item)).toList();

    print('Se cargaron ${usuarios.length} usuarios:');
    for (User u in usuarios) {
      print(u);
    }
  } catch (e) {
    print('No se pudo conectar con la API: $e');
  }
}
