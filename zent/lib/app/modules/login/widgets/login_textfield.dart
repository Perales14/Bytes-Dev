import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/login/controllers/login_controller.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({Key? key}) : super(key: key);

  static const double _inputWidth = 300.0;
  static const double _fieldSpacing = 20.0;

  LoginController get controller => Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _inputWidth,
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: _fieldSpacing),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Obx(() => TextField(
      controller: controller.emailController,
      focusNode: controller.emailFocusNode,
      style: _inputStyle,
      decoration: _getInputDecoration(
        labelText: 'Email',
        isFocused: controller.isEmailFocused.value,
      ),
    ));
  }

  Widget _buildPasswordField() {
    return Obx(() => TextField(
      controller: controller.passwordController,
      focusNode: controller.passwordFocusNode,
      obscureText: !controller.isPasswordVisible.value,
      style: _inputStyle,
      decoration: _getInputDecoration(
        labelText: 'Password',
        isFocused: controller.isPasswordFocused.value,
        suffixIcon: _buildPasswordVisibilityIcon(),
      ),
    ));
  }

  Widget _buildPasswordVisibilityIcon() {
    return IconButton(
      icon: Icon(
        controller.isPasswordVisible.value
            ? Icons.visibility
            : Icons.visibility_off,
        color: Colors.white70,
      ),
      onPressed: controller.togglePasswordVisibility,
    );
  }

  TextStyle get _inputStyle => const TextStyle(color: Colors.white);

  InputDecoration _getInputDecoration({
    required String labelText,
    required bool isFocused,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.transparent,
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      labelStyle: TextStyle(
        color: isFocused ? Colors.white : Colors.white70,
      ),
      suffixIcon: suffixIcon,
    );
  }
}
