// Widget para los botones de acción del formulario de login
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginButtons extends GetView<LoginController> {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Dimensiones adaptativas según el tamaño de pantalla
    final adaptiveWidth = size.width < 600
        ? size.width * 0.85 // Pantallas pequeñas
        : size.width < 1200
            ? size.width * 0.4 // Pantallas medianas
            : 500.0; // Pantallas grandes (máximo)
    final buttonHeight = size.width > 1200 ? 60.0 : 50.0;
    final fontSize = size.width > 1200 ? 18.0 : 16.0;

    return SizedBox(
      width: adaptiveWidth,
      child: Column(
        children: [
          // Botón principal de Login
          _buildLoginButton(theme, buttonHeight, fontSize),

          // Si se requiere integración con Google en el futuro, descomentar:
          // SizedBox(height: size.width > 1200 ? 24 : 16),
          // _buildGoogleLoginButton(theme, buttonHeight, fontSize, size),
        ],
      ),
    );
  }

  // Botón principal de login
  Widget _buildLoginButton(ThemeData theme, double height, double fontSize) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            onPressed: controller.isLoading.value ? null : controller.login,
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
          )),
    );
  }

  // Botón de login con Google (para uso futuro)
  // Widget _buildGoogleLoginButton(ThemeData theme, double height, double fontSize, Size size) {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: height,
  //     child: Obx(() => OutlinedButton.icon(
  //       style: OutlinedButton.styleFrom(
  //         side: BorderSide(
  //           color: theme.colorScheme.primary,
  //           width: size.width > 1200 ? 2.0 : 1.5
  //         ),
  //         backgroundColor: Colors.white,
  //         foregroundColor: theme.colorScheme.primary,
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(height / 2),
  //         ),
  //       ),
  //       icon: controller.isLoading.value
  //           ? SizedBox(
  //               width: 28,
  //               height: 28,
  //               child: CircularProgressIndicator(
  //                 color: theme.colorScheme.primary,
  //                 strokeWidth: 3,
  //               ),
  //             )
  //           : Image.asset(
  //               'assets/google_logo.png',
  //               height: size.width > 1200 ? 30 : 24,
  //               width: size.width > 1200 ? 30 : 24,
  //             ),
  //       label: Text(
  //         'Log in with Google',
  //         style: TextStyle(
  //           color: theme.colorScheme.primary,
  //           fontWeight: FontWeight.w500,
  //           fontSize: fontSize,
  //         ),
  //       ),
  //       onPressed: controller.isLoading.value ? null : controller.loginWithGoogle,
  //     )),
  //   );
  // }
}
