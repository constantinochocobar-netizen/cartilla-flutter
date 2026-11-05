import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/asistencia_service.dart';

class AsistenciasHoyScreen extends StatefulWidget {
  const AsistenciasHoyScreen({super.key});

  @override
  State<AsistenciasHoyScreen> createState() => _AsistenciasHoyScreenState();
}

class _AsistenciasHoyScreenState extends State<AsistenciasHoyScreen> {
  final AsistenciaService _service = AsistenciaService();

  Future<void> _limpiarDia() async {
    final borrados = await _service.limpiarHoy();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se borraron $borrados registros de hoy')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asistencias de hoy (${AsistenciaService.hoy})')),
      // Avance: la lista de hoy se actualiza sola cuando alguien escanea
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.asistenciasDeHoy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Presentes: ${docs.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: docs.isEmpty
                    ? const Center(child: Text('Todavía no hay asistencias hoy'))
                    : ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (ctx, i) {
                          final data = docs[i].data() as Map<String, dynamic>;
                          return ListTile(
                            leading: const Icon(Icons.check_circle, color: Colors.green),
                            title: Text(data['nombre'] ?? ''),
                            subtitle: Text('Hora: ${data['hora']}'),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: OutlinedButton.icon(
                  onPressed: docs.isEmpty ? null : _limpiarDia,
                  icon: const Icon(Icons.delete),
                  label: const Text('Limpiar registro del día'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
