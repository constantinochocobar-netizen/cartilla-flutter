import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tasks_provider.dart';

// ConsumerWidget: como StatelessWidget pero con acceso a Riverpod
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: lee el estado y se reconstruye cuando cambia
    final state = ref.watch(tasksProvider);
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text('Tareas pendientes', style: TextStyle(fontSize: 18, color: cs.onPrimaryContainer)),
              const SizedBox(height: 8),
              // El contador se actualiza solo cuando agregás o completás tareas
              Text(
                '${state.pendientes}',
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: cs.onPrimaryContainer),
              ),
              Text(
                state.pendientes == 0 ? '¡Todo al día! 🎉' : 'Seguí así 💪',
                style: TextStyle(color: cs.onPrimaryContainer),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _Dato(titulo: 'Total', valor: state.tareas.length)),
            const SizedBox(width: 12),
            Expanded(child: _Dato(titulo: 'Completadas', valor: state.completadas)),
          ],
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  final String titulo;
  final int valor;
  const _Dato({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$valor', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: cs.primary)),
            Text(titulo),
          ],
        ),
      ),
    );
  }
}
