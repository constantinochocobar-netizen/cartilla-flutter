import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tasks_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 56,
            backgroundImage: NetworkImage('https://picsum.photos/id/64/300/300'),
          ),
          const SizedBox(height: 16),
          const Text('Micael Chocobar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Técnico en Informática', style: TextStyle(color: cs.onSurfaceVariant)),
          const SizedBox(height: 16),
          Text('Completaste ${state.completadas} de ${state.tareas.length} tareas'),
        ],
      ),
    );
  }
}
