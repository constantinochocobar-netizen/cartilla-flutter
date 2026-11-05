# Cartilla de Flutter — Desafíos resueltos

Resoluciones de los desafíos de la **Cartilla de Flutter v5** (Desarrollo de Aplicaciones Móviles, prof. Agustín Vila, 2026).

Alumno: **Micael Constantino Chocobar**

Cada desafío está en su propia carpeta y es un proyecto independiente.

| Desafío | Carpeta | Qué hace | Paquetes usados |
|---|---|---|---|
| 0 — Tu primer repositorio | [`desafio_0_hola_flutter`](desafio_0_hola_flutter) | Proyecto creado con `flutter create`, con un segundo commit que traduce los textos (EXTRA) | — |
| 1 — Registro de alumnos | [`desafio_1_registro_alumnos`](desafio_1_registro_alumnos) | Dart puro: clase `Alumno`, promedio, estado final, mejor promedio, conteo y ranking ordenado (EXTRA) | — |
| 2 — Tarjeta personal | [`desafio_2_tarjeta_app`](desafio_2_tarjeta_app) | Foto circular, nombre, rol, Switch que cambia el fondo y botón con SnackBar | — |
| 3 — Drawer y Material 3 | [`desafio_3_drawer_m3`](desafio_3_drawer_m3) | Material 3 con `colorSchemeSeed`, Drawer, NavigationBar, banner y estadísticas, modo oscuro y FAB (EXTRA) | — |
| 4 — Tareas con Riverpod | [`desafio_4_tareas_riverpod`](desafio_4_tareas_riverpod) | `TasksState` + `TasksNotifier` (agregar, eliminar, toggleCompletada), contador compartido y prioridad con colores (EXTRA) | flutter_riverpod |
| 4B — JSON desde cero | [`desafio_4b_json`](desafio_4b_json) | Clase `User` con `fromJson`, lista de usuarios y objeto anidado `address` (EXTRA) | http |
| 4C — Migrar a GoRouter | [`desafio_4c_gorouter`](desafio_4c_gorouter) | Rutas `/`, `/login`, `/posts`, `/posts/:id`, `/profile`, redirect sin sesión, ShellRoute y `/posts?search=` (EXTRA) | go_router, http |
| 5 — Noticias con Clean Architecture | [`desafio_5_noticias`](desafio_5_noticias) | Capas presentation/domain/data, FutureBuilder con 3 estados, detalle, buscador y Provider con los posts cargados (EXTRA) | http, flutter_riverpod |
| 6 — SQLite + Hive | [`desafio_6_tareas_sqlite_hive`](desafio_6_tareas_sqlite_hive) | CRUD de tareas en SQLite, Dismissible, preferencias en Hive, modo oscuro global y filtro (EXTRA) | sqflite, path, hive, hive_flutter |
| 7 — Firebase | [`desafio_7_firebase`](desafio_7_firebase) | Login, registro, tareas por usuario en Firestore en tiempo real, cerrar sesión y sesión persistente (EXTRA) | firebase_core, firebase_auth, cloud_firestore |
| 8 — Asistencia con QR | [`desafio_8_asistencia_qr`](desafio_8_asistencia_qr) | Escaneo de QR con linterna, guardado en Firestore, aviso con notificación local, asistencias del día, limpiar el día e historial (EXTRA) | mobile_scanner, flutter_local_notifications, firebase_core, cloud_firestore |

## Cómo correr un desafío

```bash
cd desafio_X_nombre
flutter pub get   # OBLIGATORIO después de clonar
flutter run
```

El Desafío 1 y el 4B son Dart puro:

```bash
dart run desafio_1_registro_alumnos/registro_alumnos.dart

cd desafio_4b_json
dart pub get
dart run
```

Los desafíos 6, 7 y 8 usan SQLite, Firebase, la cámara y notificaciones: hay que correrlos en un celular o emulador Android.
