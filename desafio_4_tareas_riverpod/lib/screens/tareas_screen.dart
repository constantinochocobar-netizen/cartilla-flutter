import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tasks_provider.dart';

class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _ctrl = TextEditingController();

  String _prioridad = 'media';

  Color _colorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'alta':
        return Colors.red;
      case 'baja':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Color _fondoPrioridad(String prioridad) {
    switch (prioridad) {
      case 'alta':
        return Colors.red.shade50;
      case 'baja':
        return Colors.green.shade50;
      default:
        return Colors.orange.shade50;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _agregar() {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    ref.read(tasksProvider.notifier).agregar(texto, prioridad: _prioridad);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

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
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _agregar,
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
        // Avance: el extra, ahora cada tarea tiene prioridad alta, media o baja
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text('Prioridad:'),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _prioridad,
                items: const [
                  DropdownMenuItem(value: 'alta', child: Text('Alta')),
                  DropdownMenuItem(value: 'media', child: Text('Media')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                ],
                onChanged: (valor) => setState(() => _prioridad = valor ?? 'media'),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text('${state.pendientes} pendientes de ${state.tareas.length}')),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: state.tareas.isEmpty
              ? const Center(child: Text('No hay tareas. ¡Agregá la primera!'))
              : ListView.builder(
                  itemCount: state.tareas.length,
                  itemBuilder: (ctx, i) {
                    final tarea = state.tareas[i];
                    return ListTile(
                      tileColor: _fondoPrioridad(tarea.prioridad),
                      leading: Checkbox(
                        value: tarea.completada,
                        onChanged: (_) => ref.read(tasksProvider.notifier).toggleCompletada(i),
                      ),
                      title: Text(
                        tarea.titulo,
                        style: TextStyle(
                          decoration: tarea.completada ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        'Prioridad ${tarea.prioridad}',
                        style: TextStyle(color: _colorPrioridad(tarea.prioridad), fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ref.read(tasksProvider.notifier).eliminar(i),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
