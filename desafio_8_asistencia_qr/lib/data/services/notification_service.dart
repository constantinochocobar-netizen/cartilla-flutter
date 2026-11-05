// data/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Servicio de notificaciones — clase estática para acceder desde cualquier lado
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // Inicializar — llamar ANTES de runApp() en main.dart
  static Future<void> init() async {
    // Configuración para Android
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS — pide los permisos al usuario
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      // Qué hacer cuando el usuario toca la notificación
      onDidReceiveNotificationResponse: (details) {
        print('Usuario tocó la notificación: ${details.payload}');
      },
    );

    // Android 13 o superior: hay que pedir permiso para mostrar notificaciones
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Mostrar una notificación inmediata
  static Future<void> mostrar({
    required String titulo,
    required String cuerpo,
    String? payload,
  }) async {
    await _plugin.show(
      // ID único para esta notificación
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titulo,
      cuerpo,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_principal',
          'Notificaciones',
          channelDescription: 'Notificaciones generales de la app',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
}
