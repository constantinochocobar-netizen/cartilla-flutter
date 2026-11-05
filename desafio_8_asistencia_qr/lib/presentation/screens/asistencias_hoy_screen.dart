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
  late final Stream<QuerySnapshot> _stream = _service.asistenciasDeHoy();

  // Elimina de Firestore los registros del día actual
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
      appBar: AppBar(
        title: Text('Asistencias de hoy (${AsistenciaService.hoy})'),
      ),
      // StreamBuilder: se actualiza en tiempo real cuando alguien escanea
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;
          // Ordenamos por hora en la app (la más reciente primero)
          final lista = docs.map((d) => d.data() as Map<String, dynamic>).toList();
          lista.sort((a, b) => (b['hora'] ?? '').compareTo(a['hora'] ?? ''));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Presentes: ${lista.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: lista.isEmpty
                    ? const Center(child: Text('Todavía no hay asistencias hoy'))
                    : ListView.builder(
                        itemCount: lista.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(child: Text('${lista.length - i}')),
                          title: Text(lista[i]['nombre'] ?? ''),
                          subtitle: Text('Hora: ${lista[i]['hora']}'),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: OutlinedButton.icon(
                  onPressed: lista.isEmpty ? null : _limpiarDia,
                  icon: const Icon(Icons.delete_sweep),
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
