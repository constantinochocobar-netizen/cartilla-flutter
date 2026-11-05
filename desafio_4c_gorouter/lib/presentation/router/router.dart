// presentation/router/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import '../screens/app_shell.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/profile_screen.dart';

// El router se define como una variable global
final appRouter = GoRouter(
  // initialLocation: la ruta que se muestra al abrir la app
  initialLocation: '/',

  routes: [
    // ── ShellRoute: estas rutas comparten el NavigationBar ─────────
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/posts',
          builder: (context, state) {
            // EXTRA: parámetro de búsqueda en la URL → /posts?search=flutter
            final String busqueda = state.uri.queryParameters['search'] ?? '';
            return PostsScreen(busqueda: busqueda);
          },
          routes: [
            // Sub-ruta: /posts/:id
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final int id = int.parse(state.pathParameters['id']!);
                return DetailScreen(postId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // ── Rutas fuera del shell (sin NavigationBar) ──────────────────
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],

  // redirect: se ejecuta ANTES de mostrar cada ruta
  redirect: (BuildContext context, GoRouterState state) {
    final bool estaLogueado = AuthService.estaLogueado;
    final bool esRutaPublica = state.uri.path == '/login';

    // Sin sesión y quiere ir a una ruta protegida → al login
    if (!estaLogueado && !esRutaPublica) return '/login';

    // Con sesión y quiere ir al login → al inicio
    if (estaLogueado && esRutaPublica) return '/';

    // null = navegar normalmente
    return null;
  },

  // Qué mostrar si la ruta no existe
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Página no encontrada: ${state.uri}'),
    ),
  ),
);
