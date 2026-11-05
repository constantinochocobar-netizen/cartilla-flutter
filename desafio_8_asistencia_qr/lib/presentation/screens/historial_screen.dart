import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/asistencia_service.dart';

// EXTRA: historial de asistencias de fechas anteriores
class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late final Stream<QuerySnapshot> _stream = AsistenciaService().historial();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Agrupar los registros por fecha: { '2026-11-05': [ ... ], ... }
          final Map<String, List<Map<String, dynamic>>> porFecha = {};
          for (final doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final String fecha = data['fecha'] ?? '';
            if (!porFecha.containsKey(fecha)) porFecha[fecha] = [];
            porFecha[fecha]!.add(data);
          }
          final fechas = porFecha.keys.toList();

          if (fechas.isEmpty) {
            return const Center(child: Text('Todavía no hay asistencias registradas'));
          }

          return ListView.builder(
            itemCount: fechas.length,
            itemBuilder: (context, i) {
              final fecha = fechas[i];
              final registros = porFecha[fecha]!;
              registros.sort((a, b) => (a['hora'] ?? '').compareTo(b['hora'] ?? ''));
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: cs.primary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(fecha == AsistenciaService.hoy ? '$fecha (hoy)' : fecha,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Text('${registros.length} presentes'),
                        ],
                      ),
                      const Divider(),
                      for (final r in registros) Text('• ${r['nombre']} — ${r['hora']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
