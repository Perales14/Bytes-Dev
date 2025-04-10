import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/login/controllers/login_controller.dart';

class LoginButtons extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Mismo ancho que los TextFields
      child: Column(
        children: [
          // Botón principal de Login
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: controller.login,
              child: Text(
                'Log In',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Botón de Google
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.transparent),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Image.asset(
                'assets/logo_google.png',
                height: 24,
                width: 24,
              ),
              label: Text(
                'Log in with Google',
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: controller.loginWithGoogle,
            ),
          ),
        ],
      ),
    );
  }
}
