// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:zent/modules/home/controllers/home_controller.dart';
// import 'package:zent/shared/widgets/main_layout.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MainLayout(
//       pageTitle: 'Inicio',
//       child: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/home/controllers/home_controller.dart';
import 'package:zent/app/shared/factories/form_factory.dart';
import 'package:zent/app/shared/widgets/main_layout.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      pageTitle: 'Inicio',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido al Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Selector de tipo de formulario
            _buildFormSelector(context),
            const SizedBox(height: 20),

            // Formulario dinámico
            Obx(() => Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child:
                      FormFactory.createForm(controller.selectedFormType.value),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSelector(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona un tipo de formulario:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSelectorButton(
                    context, 'Empleado', FormType.employee, Icons.person),
                const SizedBox(width: 16),
                _buildSelectorButton(
                    context, 'Cliente', FormType.client, Icons.business),
                const SizedBox(width: 16),
                _buildSelectorButton(context, 'Proveedor', FormType.provider,
                    Icons.local_shipping),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorButton(
      BuildContext context, String label, FormType type, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedFormType.value == type;

      return ElevatedButton.icon(
        onPressed: () => controller.selectedFormType.value = type,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
    });
  }
}
