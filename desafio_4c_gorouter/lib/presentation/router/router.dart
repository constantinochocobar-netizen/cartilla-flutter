import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';
import '../screens/app_shell.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // Avance: con ShellRoute el NavigationBar queda fijo abajo
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
            final String busqueda = state.uri.queryParameters['search'] ?? '';
            return PostsScreen(busqueda: busqueda);
          },
          routes: [
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

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],

  // Avance: si no hay sesión te manda al /login solo
  redirect: (BuildContext context, GoRouterState state) {
    final bool estaLogueado = AuthService.estaLogueado;
    final bool esRutaPublica = state.uri.path == '/login';

    if (!estaLogueado && !esRutaPublica) return '/login';

    if (estaLogueado && esRutaPublica) return '/';

    return null;
  },

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Página no encontrada: ${state.uri}'),
    ),
  ),
);
