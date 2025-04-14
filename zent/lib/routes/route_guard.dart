import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/data/services/session_service.dart';

/// Middleware para proteger rutas basado en autenticación y roles de usuario
class RouteGuard extends GetMiddleware {
  // Obtener el servicio de sesión para verificar la autenticación
  final sessionService = Get.find<SessionService>();

  // Lista de roles permitidos para acceder a la ruta
  final List<int>? allowedRoles;

  // Ruta a la que redirigir si el acceso es denegado
  final String? redirectRoute;

  RouteGuard({
    this.allowedRoles,
    this.redirectRoute = '/login',
  });

  @override
  RouteSettings? redirect(String? route) {
    // Verificar si el usuario está autenticado
    if (!sessionService.isAuthenticated) {
      // Si no está autenticado, redirigir a la página de login
      return RouteSettings(name: redirectRoute);
    }

    // Si hay roles permitidos especificados, verificar si el usuario tiene el rol adecuado
    if (allowedRoles != null && allowedRoles!.isNotEmpty) {
      final userRoleId = sessionService.currentUser?.roleId;
      // Si el rol del usuario no está en la lista de roles permitidos
      if (userRoleId == null || !allowedRoles!.contains(userRoleId)) {
        // Redirigir a una página de acceso denegado o a la página principal
        return const RouteSettings(name: '/access-denied');
      }
    }

    // Si pasa todas las verificaciones, permitir acceso a la ruta solicitada
    return null;
  }

  // Página mostrada durante la redirección
  @override
  Widget onPageBuilding(BuildContext context, Widget page) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Middleware para rutas que solo pueden ser accedidas por usuarios no autenticados
/// Por ejemplo, la pantalla de login no debería ser accesible si ya hay sesión
class NoAuthRequiredGuard extends GetMiddleware {
  final sessionService = Get.find<SessionService>();
  final String redirectRoute;

  NoAuthRequiredGuard({
    this.redirectRoute = '/home',
  });

  @override
  RouteSettings? redirect(String? route) {
    // Si el usuario ya está autenticado, redirigir a la página principal
    if (sessionService.isAuthenticated) {
      return RouteSettings(name: redirectRoute);
    }
    return null;
  }
}

/// Página para mostrar cuando el acceso es denegado
class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceso Denegado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              'Acceso Denegado',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes permisos para acceder a esta sección.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
