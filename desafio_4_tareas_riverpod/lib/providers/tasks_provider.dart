import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Una tarea ────────────────────────────────────────────────────
class Tarea {
  final String titulo;
  final bool completada;

  const Tarea({required this.titulo, this.completada = false});

  // copyWith: crea una copia cambiando solo algunos campos
  Tarea copyWith({String? titulo, bool? completada}) => Tarea(
        titulo: titulo ?? this.titulo,
        completada: completada ?? this.completada,
      );
}

// ── El estado: la lista de tareas ────────────────────────────────
class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  // Getters calculados — no se guardan, se calculan cuando se piden
  int get completadas => tareas.where((t) => t.completada).length;
  int get pendientes => tareas.length - completadas;
}

// ── El Notifier: guarda el estado y tiene los métodos para modificarlo ──
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  // Agregar una tarea — se crea un nuevo estado
  void agregar(String titulo) {
    if (titulo.trim().isEmpty) return;
    state = TasksState(
      tareas: [...state.tareas, Tarea(titulo: titulo.trim())],
    );
  }

  // Eliminar una tarea por índice
  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(tareas: nuevas);
  }

  // Marcar / desmarcar una tarea como completada
  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];
    nuevas[indice] = nuevas[indice].copyWith(completada: !nuevas[indice].completada);
    state = TasksState(tareas: nuevas);
  }
}

// ── El Provider — lo que usan los widgets para acceder al estado ──
final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);
