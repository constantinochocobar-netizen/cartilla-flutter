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

  // EXTRA: filtro con menú desplegable → 'todas', 'pendientes', 'completadas'
  String _filtro = 'todas';

  @override
  void initState() {
    super.initState();
    _cargar(); // leer las tareas guardadas al abrir la pantalla
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

  Future<void> _agregar() async {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    await _db.insertar(Tarea(titulo: texto, fecha: DateTime.now().toIso8601String()));
    _ctrl.clear();
    await _cargar();
  }

  Future<void> _toggle(Tarea tarea) async {
    await _db.actualizar(tarea.copyWith(completada: !tarea.completada));
    await _cargar();
  }

  Future<void> _eliminar(Tarea tarea) async {
    // Dismissible exige sacar el ítem de la lista EN EL MOMENTO
    setState(() => _tareas.removeWhere((t) => t.id == tarea.id));
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
        // ── TextField + botón Agregar ───────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
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

        // ── EXTRA: menú desplegable para filtrar ───────────────────
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

        // ── Lista ───────────────────────────────────────────────────
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : _tareas.isEmpty
                  ? const Center(child: Text('No hay tareas para mostrar'))
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, i) {
                        final tarea = _tareas[i];
                        // Dismissible: deslizar para eliminar
                        return Dismissible(
                          key: ValueKey(tarea.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
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
                            subtitle: Text('Creada: ${tarea.fecha.substring(0, 16).replaceAll('T', ' ')}'),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      },
                    ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Deslizá una tarea hacia la izquierda para eliminarla', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
