import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/modules/home/controllers/home_controller.dart';
import 'package:zent/shared/widgets/form/form.dart';
import 'package:zent/shared/widgets/main_layout.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      pageTitle: 'Inicio',
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido al Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),

              // Add the refactored form to test it
              const Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 16),
                child: CustomForm(
                  showSalario: true,
                ),
              ),

              // Space after form
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
