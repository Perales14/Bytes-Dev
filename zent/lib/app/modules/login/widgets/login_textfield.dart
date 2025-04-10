import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginTextField extends GetView<LoginController> {
  const LoginTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 300, // Ancho controlado para los campos
      child: Column(
        children: [
          // Campo de Email
          Obx(
            () => TextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              style: TextStyle(
                  color: theme
                      .colorScheme.onSurface), // Color oscuro para fondo blanco
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
                      color: theme.colorScheme.primary.withOpacity(0.6)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                labelStyle: TextStyle(
                  color: controller.isEmailFocused.value
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.7),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Campo de Password
          Obx(
            () => TextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              obscureText: !controller.isPasswordVisible.value,
              style: TextStyle(
                  color: theme
                      .colorScheme.onSurface), // Color oscuro para fondo blanco
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
                      color: theme.colorScheme.primary.withOpacity(0.6)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                labelStyle: TextStyle(
                  color: controller.isPasswordFocused.value
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.7),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: theme.colorScheme.primary.withOpacity(0.7),
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
