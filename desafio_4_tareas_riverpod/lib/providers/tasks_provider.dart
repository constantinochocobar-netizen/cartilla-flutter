import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tarea {
  final String titulo;
  final bool completada;
  final String prioridad;

  const Tarea({required this.titulo, this.completada = false, this.prioridad = 'media'});

  Tarea copyWith({String? titulo, bool? completada}) => Tarea(
        titulo: titulo ?? this.titulo,
        completada: completada ?? this.completada,
        prioridad: prioridad,
      );
}

class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  int get completadas => tareas.where((t) => t.completada).length;
  int get pendientes => tareas.length - completadas;
}

// Avance: el notifier ya agrega, elimina y marca completadas
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  void agregar(String titulo, {String prioridad = 'media'}) {
    if (titulo.trim().isEmpty) return;
    state = TasksState(
      tareas: [...state.tareas, Tarea(titulo: titulo.trim(), prioridad: prioridad)],
    );
  }

  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(tareas: nuevas);
  }

  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];
    nuevas[indice] = nuevas[indice].copyWith(completada: !nuevas[indice].completada);
    state = TasksState(tareas: nuevas);
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);
