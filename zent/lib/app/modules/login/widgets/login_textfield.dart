import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/login/controllers/login_controller.dart';

class LoginTextField extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Ancho controlado para los campos
      child: Column(
        children: [
          // Campo de Email
          Obx(
            () => TextField(
              controller: controller.textController,
              focusNode: controller.emailFocusNode,
              style: TextStyle(color: Colors.white), // Color del texto
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.transparent, // Relleno transparente
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: controller.isEmailFocused.value 
                      ? Colors.white 
                      : Colors.white70,
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
              style: TextStyle(color: Colors.white), // Color del texto
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.transparent, // Relleno transparente
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: controller.isPasswordFocused.value 
                      ? Colors.white 
                      : Colors.white70,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
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
