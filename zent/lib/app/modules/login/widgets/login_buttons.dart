import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginButtons extends GetView<LoginController> {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Calcula un ancho adaptativo con límites mínimo y máximo
    final adaptiveWidth = size.width < 600
        ? size.width * 0.85 // En pantallas pequeñas, 85% del ancho
        : size.width < 1200
            ? size.width * 0.4 // En pantallas medianas, 40% del ancho
            : 500.0; // En pantallas grandes, máximo 500px

    // Escala la altura de los botones para pantallas grandes
    final buttonHeight = size.width > 1200 ? 60.0 : 50.0;
    final fontSize = size.width > 1200 ? 18.0 : 16.0;

    return SizedBox(
      width: adaptiveWidth,
      child: Column(
        children: [
          // Botón principal de Login
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          buttonHeight / 2), // Border radius más grande
                    ),
                  ),
                  onPressed:
                      controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? SizedBox(
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
          ),
          SizedBox(height: size.width > 1200 ? 24 : 16),
          // Botón de Google
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: Obx(() => OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: theme.colorScheme.primary,
                        width: size.width > 1200 ? 2.0 : 1.5),
                    backgroundColor: Colors.white,
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonHeight / 2),
                    ),
                  ),
                  icon: controller.isLoading.value
                      ? SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                            strokeWidth: 3,
                          ),
                        )
                      : Image.asset(
                          'assets/google_logo.png',
                          height: size.width > 1200 ? 30 : 24,
                          width: size.width > 1200 ? 30 : 24,
                        ),
                  label: Text(
                    'Log in with Google',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize,
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.loginWithGoogle,
                )),
          ),
        ],
      ),
    );
  }
}
