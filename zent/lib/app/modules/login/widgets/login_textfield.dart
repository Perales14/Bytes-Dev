// Widget para los campos de texto del formulario de login
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginTextField extends GetView<LoginController> {
  const LoginTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Cálculo del ancho adaptativo para diferentes tamaños de pantalla
    final adaptiveWidth = size.width < 600
        ? size.width * 0.85 // Pantallas pequeñas: 85% del ancho
        : size.width < 1200
            ? size.width * 0.4 // Pantallas medianas: 40% del ancho
            : 500.0; // Pantallas grandes: máximo 500px

    return SizedBox(
      width: adaptiveWidth,
      child: Column(
        children: [
          // Campo de Email
          _buildEmailField(theme, size),
          SizedBox(height: size.width > 1200 ? 30 : 20),
          // Campo de Contraseña
          _buildPasswordField(theme, size),
        ],
      ),
    );
  }

  // Construye el campo de email con manejo de errores
  Widget _buildEmailField(ThemeData theme, Size size) {
    return Obx(() => TextField(
          controller: controller.emailController,
          focusNode: controller.emailFocusNode,
          style: TextStyle(
            color: Colors.black, // Cambiado a negro fijo
            fontSize: size.width > 1200 ? 18 : 16,
          ),
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.transparent,
            border: _createBorder(theme, false),
            enabledBorder: _createBorder(
              theme,
              controller.hasEmailError.value,
            ),
            focusedBorder: _createBorder(
              theme,
              controller.hasEmailError.value,
              isFocused: true,
            ),
            labelStyle: _getLabelStyle(
              theme,
              controller.isEmailFocused.value,
              controller.hasEmailError.value,
              size,
            ),
            errorText: controller.hasEmailError.value
                ? controller.emailErrorText.value
                : null,
          ),
        ));
  }

  // Construye el campo de contraseña con manejo de errores y visibilidad
  Widget _buildPasswordField(ThemeData theme, Size size) {
    return Obx(() => TextField(
          controller: controller.passwordController,
          focusNode: controller.passwordFocusNode,
          obscureText: !controller.isPasswordVisible.value,
          style: TextStyle(
            color: Colors.black, // Cambiado a negro fijo
            fontSize: size.width > 1200 ? 18 : 16,
          ),
          decoration: InputDecoration(
            labelText: 'Password',
            filled: true,
            fillColor: Colors.transparent,
            border: _createBorder(theme, false),
            enabledBorder: _createBorder(
              theme,
              controller.hasPasswordError.value,
            ),
            focusedBorder: _createBorder(
              theme,
              controller.hasPasswordError.value,
              isFocused: true,
            ),
            labelStyle: _getLabelStyle(
              theme,
              controller.isPasswordFocused.value,
              controller.hasPasswordError.value,
              size,
            ),
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
        ));
  }

  // Crea el borde para los campos de texto
  UnderlineInputBorder _createBorder(ThemeData theme, bool hasError,
      {bool isFocused = false}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: hasError
            ? theme.colorScheme.error
            : theme.colorScheme.primary.withOpacity(isFocused ? 1.0 : 0.6),
      ),
    );
  }

  // Obtiene el estilo para las etiquetas de los campos
  TextStyle _getLabelStyle(
      ThemeData theme, bool isFocused, bool hasError, Size size) {
    return TextStyle(
      color: isFocused
          ? hasError
              ? theme.colorScheme.error
              : theme.colorScheme.primary
          : theme.colorScheme.primary.withOpacity(0.7),
      fontSize: size.width > 1200 ? 18 : 16,
    );
  }
}
