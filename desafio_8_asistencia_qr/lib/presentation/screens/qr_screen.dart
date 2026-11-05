import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/services/asistencia_service.dart';
import '../../data/services/notification_service.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String? _resultado; // el nombre leído del QR
  String _mensaje = '';
  bool _yaEstaba = false;
  bool _activo = true; // true = escaneando, false = pausado

  final MobileScannerController _ctrl = MobileScannerController();
  final AsistenciaService _service = AsistenciaService();

  // IMPORTANTE: liberar la cámara cuando el widget se destruye
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _procesarCodigo(String codigo) async {
    if (!_activo) return; // evitar procesar múltiples detecciones
    final nombre = codigo.trim();
    setState(() {
      _resultado = nombre;
      _activo = false;
      _mensaje = 'Guardando...';
    });
    _ctrl.stop(); // pausar la cámara

    try {
      final yaEstaba = await _service.yaRegistradoHoy(nombre);
      if (yaEstaba) {
        // Si el alumno ya está registrado hoy → notificación local de aviso
        await NotificationService.mostrar(
          titulo: 'Asistencia repetida',
          cuerpo: '$nombre ya tiene asistencia registrada hoy',
          payload: 'asistencia_repetida',
        );
        setState(() {
          _yaEstaba = true;
          _mensaje = '$nombre ya estaba registrado hoy';
        });
      } else {
        await _service.registrar(nombre);
        setState(() {
          _yaEstaba = false;
          _mensaje = 'Asistencia guardada a las ${AsistenciaService.horaDe(DateTime.now())}';
        });
      }
    } catch (e) {
      setState(() => _mensaje = 'Error al guardar: $e');
    }
  }

  // Limpiar el resultado y volver a escanear
  void _escanearDeNuevo() {
    setState(() {
      _resultado = null;
      _activo = true;
      _mensaje = '';
    });
    _ctrl.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear asistencia'),
        actions: [
          // Botón para encender/apagar la linterna
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _ctrl.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _ctrl,
              onDetect: (BarcodeCapture capture) {
                if (capture.barcodes.isNotEmpty) {
                  final codigo = capture.barcodes.first.rawValue;
                  if (codigo != null) _procesarCodigo(codigo);
                }
              },
            ),
          ),

          // Panel que aparece cuando se detecta un código
          if (_resultado != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _yaEstaba ? Colors.orange.shade50 : Colors.green.shade50,
              child: Column(
                children: [
                  Icon(_yaEstaba ? Icons.warning_amber : Icons.check_circle,
                      color: _yaEstaba ? Colors.orange : Colors.green, size: 48),
                  const SizedBox(height: 8),
                  SelectableText(_resultado!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_mensaje),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _escanearDeNuevo,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear otro código'),
                  ),
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Apuntá la cámara al código QR del alumno'),
            ),
        ],
      ),
    );
  }
}
