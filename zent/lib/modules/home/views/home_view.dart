import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/modules/home/controllers/home_controller.dart';
import 'package:zent/shared/factories/form_factory.dart';
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

              // Example of creating a form dynamically - Here Employee Form
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: FormFactory.createForm(FormType.employee),
              ),

              const SizedBox(height: 40),

              // Example of creating another form type - Here Client Form
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: FormFactory.createForm(FormType.client),
              ),

              const SizedBox(height: 40),

              // Add Provider Form
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: FormFactory.createForm(FormType.provider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
