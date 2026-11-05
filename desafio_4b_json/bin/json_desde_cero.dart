import 'dart:convert';
import 'package:http/http.dart' as http;

class Address {
  final String city;
  final String zipcode;

  Address({required this.city, required this.zipcode});

  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(city: json['city'], zipcode: json['zipcode']);

  @override
  String toString() => '$city ($zipcode)';
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
    );
  }

  @override
  String toString() => '#$id $name (@$username) — $email — vive en $address';
}

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
  print('===== 1) Un usuario desde un JSON de ejemplo =====');

  final Map<String, dynamic> mapa = jsonDecode(jsonUnUsuario);
  print('El JSON empieza con { → es un OBJETO → Map. Nombre en el mapa: ${mapa['name']}');

  final User usuario = User.fromJson(mapa);
  print(usuario);

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

    final List<dynamic> lista = jsonDecode(respuesta.body);
    final List<User> usuarios = lista.map((item) => User.fromJson(item)).toList();

    print('Se cargaron ${usuarios.length} usuarios:');
    for (User u in usuarios) {
      print(u);
    }
  } catch (e) {
    print('No se pudo conectar con la API: $e');
  }
}
