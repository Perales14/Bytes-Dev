import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/login/controllers/login_controller.dart';
import 'login_buttons.dart';
import 'login_textfield.dart';

class LoginMain extends GetView<LoginController> {
  const LoginMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left column with centered text
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Text(
                'Hola',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        
        // Right column with login content
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BIENVENIDO DE NUEVO',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                LoginTextField(),
                const SizedBox(height: 32),
                LoginButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}