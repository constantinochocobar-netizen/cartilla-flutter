import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tasks_provider.dart';

// ConsumerStatefulWidget: tiene ref (Riverpod) y también setState / dispose
class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose(); // liberar la memoria del controlador
    super.dispose();
  }

  void _agregar() {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    // ref.read: ejecuta ACCIONES sin reconstruir el widget
    ref.read(tasksProvider.notifier).agregar(texto);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    return Column(
      children: [
        // ── TextField para agregar tareas ───────────────────────────
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
              ElevatedButton(
                onPressed: _agregar,
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
        Text('${state.pendientes} pendientes de ${state.tareas.length}'),
        const SizedBox(height: 8),

        // ── Lista de tareas ─────────────────────────────────────────
        Expanded(
          child: state.tareas.isEmpty
              ? const Center(child: Text('No hay tareas. ¡Agregá la primera!'))
              : ListView.builder(
                  itemCount: state.tareas.length,
                  itemBuilder: (ctx, i) {
                    final tarea = state.tareas[i];
                    return ListTile(
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
