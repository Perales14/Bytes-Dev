import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginTextField extends GetView<LoginController> {
  const LoginTextField({super.key});

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

    return SizedBox(
      width: adaptiveWidth,
      child: Column(
        children: [
          // Campo de Email
          Obx(
            () => TextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: size.width > 1200 ? 18 : 16,
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.transparent,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.6)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: controller.hasEmailError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary.withOpacity(0.6)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: controller.hasEmailError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary),
                ),
                labelStyle: TextStyle(
                  color: controller.isEmailFocused.value
                      ? controller.hasEmailError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.7),
                  fontSize: size.width > 1200 ? 18 : 16,
                ),
                // Mostrar mensaje de error si existe
                errorText: controller.hasEmailError.value
                    ? controller.emailErrorText.value
                    : null,
              ),
            ),
          ),
          SizedBox(height: size.width > 1200 ? 30 : 20),
          // Campo de Password
          Obx(
            () => TextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              obscureText: !controller.isPasswordVisible.value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: size.width > 1200 ? 18 : 16,
              ),
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.transparent,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.6)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: controller.hasPasswordError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary.withOpacity(0.6)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: controller.hasPasswordError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary),
                ),
                labelStyle: TextStyle(
                  color: controller.isPasswordFocused.value
                      ? controller.hasPasswordError.value
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.7),
                  fontSize: size.width > 1200 ? 18 : 16,
                ),
                // Mostrar mensaje de error si existe
                errorText: controller.hasPasswordError.value
                    ? controller.passwordErrorText.value
                    : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: controller.hasPasswordError.value
                        ? theme.colorScheme.error.withOpacity(0.7)
                        : theme.colorScheme.primary.withOpacity(0.7),
                    size: size.width > 1200 ? 24 : 20,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
