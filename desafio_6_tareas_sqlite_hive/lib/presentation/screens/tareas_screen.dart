import 'package:flutter/material.dart';
import '../../data/local/local_database.dart';
import '../../domain/entities/tarea.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final LocalDatabase _db = LocalDatabase();
  final TextEditingController _ctrl = TextEditingController();

  List<Tarea> _tareas = [];
  bool _cargando = true;
  String _filtro = 'todas';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    List<Tarea> lista;
    if (_filtro == 'pendientes') {
      lista = await _db.obtenerPorEstado(false);
    } else if (_filtro == 'completadas') {
      lista = await _db.obtenerPorEstado(true);
    } else {
      lista = await _db.obtenerTodas();
    }
    if (mounted) {
      setState(() {
        _tareas = lista;
        _cargando = false;
      });
    }
  }

  // Avance: ya guarda en SQLite y no se borra al cerrar la app
  Future<void> _agregar() async {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    await _db.insertar(Tarea(titulo: texto, fecha: '${DateTime.now()}'));
    _ctrl.clear();
    await _cargar();
  }

  Future<void> _toggle(Tarea tarea) async {
    await _db.actualizar(tarea.copyWith(completada: !tarea.completada));
    await _cargar();
  }

  Future<void> _eliminar(Tarea tarea) async {
    setState(() => _tareas.remove(tarea));
    await _db.eliminar(tarea.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarea "${tarea.titulo}" eliminada')),
    );
    await _cargar();
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
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _agregar, child: const Text('Agregar')),
            ],
          ),
        ),
        // Avance: el extra, filtro de pendientes y completadas con menú desplegable
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Mostrar: '),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _filtro,
                items: const [
                  DropdownMenuItem(value: 'todas', child: Text('Todas')),
                  DropdownMenuItem(value: 'pendientes', child: Text('Pendientes')),
                  DropdownMenuItem(value: 'completadas', child: Text('Completadas')),
                ],
                onChanged: (valor) {
                  setState(() => _filtro = valor ?? 'todas');
                  _cargar();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : _tareas.isEmpty
                  ? const Center(child: Text('No hay tareas para mostrar'))
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, i) {
                        final tarea = _tareas[i];
                        return Dismissible(
                          key: Key('${tarea.id}'),
                          background: Container(
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) => _eliminar(tarea),
                          child: CheckboxListTile(
                            value: tarea.completada,
                            onChanged: (_) => _toggle(tarea),
                            title: Text(
                              tarea.titulo,
                              style: TextStyle(
                                decoration: tarea.completada ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Text('Creada: ${tarea.fecha}'),
                          ),
                        );
                      },
                    ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Deslizá una tarea para eliminarla', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
