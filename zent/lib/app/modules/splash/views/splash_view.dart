// Splash screen mostrada durante la inicialización de la app y cierre de sesión
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o título de la aplicación
                Text(
                  'ZENT',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 72,
                    letterSpacing: 8,
                  ),
                ),

                const SizedBox(height: 48),

                // Indicador de carga
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),

                const SizedBox(height: 24),

                // Texto animado para mostrar el estado de carga según el modo
                Text(
                  controller.loadingMessage.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Mensaje adicional para cierre de sesión
                if (controller.isLoggingOut.value) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Gracias por usar ZENT',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            )),
      ),
    );
  }
}
