import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferencias').listenable(),
      builder: (context, box, _) {
        final bool oscuro = box.get('modoOscuro', defaultValue: false);
        final bool notificaciones = box.get('notificaciones', defaultValue: true);

        // Avance: los dos Switch se guardan en Hive y quedan al reiniciar
        return ListView(
          children: [
            SwitchListTile(
              title: const Text('Modo oscuro'),
              subtitle: const Text('Se aplica a toda la app'),
              value: oscuro,
              onChanged: (valor) => box.put('modoOscuro', valor),
            ),
            SwitchListTile(
              title: const Text('Notificaciones'),
              subtitle: Text(notificaciones ? 'Activadas' : 'Desactivadas'),
              value: notificaciones,
              onChanged: (valor) => box.put('notificaciones', valor),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Las tareas se guardan en SQLite y las preferencias en Hive. '
                  'Cerrá y volvé a abrir la app: todo sigue ahí.'),
            ),
          ],
        );
      },
    );
  }
}
