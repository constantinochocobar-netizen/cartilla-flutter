import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/tareas_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TareasService _service = TareasService();
  final TextEditingController _ctrl = TextEditingController();
  late final Stream<QuerySnapshot> _stream = _service.tareasDelUsuario();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _agregar() async {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    _ctrl.clear();
    try {
      await _service.agregarTarea(texto);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear tarea: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: InputDecoration(
                    labelText: 'Nueva tarea',
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onSubmitted: (_) => _agregar(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _agregar, child: const Text('Agregar')),
            ],
          ),
        ),
        // StreamBuilder: la lista se actualiza en tiempo real
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(child: Text('Todavía no tenés tareas en la nube'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (ctx, i) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  final bool completada = data['completada'] ?? false;
                  return ListTile(
                    leading: Switch(
                      value: completada,
                      onChanged: (val) => _service.actualizarTarea(docs[i].id, val),
                    ),
                    title: Text(
                      data['titulo'] ?? '',
                      style: TextStyle(decoration: completada ? TextDecoration.lineThrough : null),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _service.eliminarTarea(docs[i].id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
