import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/role_service.dart';
import '../controllers/employees_controller.dart';
import 'add_employee_card.dart';
import 'emplooyees_card.dart';

class EmployeesCardsGrid extends StatelessWidget {
  final List<UserModel> employees;
  final VoidCallback onAddEmployee;
  final EmployeesController controller;

  // Constantes de dimensiones
  static const double cardWidth = 300.0;
  static const double cardHeight = 170.0;
  static const double spacing = 28.0;
  static const double padding = 28.0;

  const EmployeesCardsGrid({
    super.key,
    required this.employees,
    required this.onAddEmployee,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Nos aseguramos de que los roles estén cargados
    controller.loadRolesIfNeeded();

    final width = MediaQuery.of(context).size.width;
    final availableWidth = width - (padding * 2);
    final cardsPerRow =
        ((availableWidth + spacing) / (cardWidth + spacing)).floor();
    final itemsPerRow = cardsPerRow > 0 ? cardsPerRow : 1;
    final itemCount = employees.length + 1;

    return GridView.builder(
      padding: const EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: cardWidth / cardHeight,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return AddEmployeeCard(onTap: onAddEmployee);
        }

        final employee = employees[index - 1];
        String role = employee.roleId == 1 ? 'Líder' : 'Empleado';

        // Utilizamos Obx para reaccionar a cambios en la lista de roles
        return Obx(() {
          // Obtener el nombre del rol de forma síncrona
          String position = controller.getRoleName(employee.roleId);
          return EmployeesCard(
            name: employee.fullName,
            position: position,
            role: role,
            projectCount: 2,
            taskCount: 4,
            onTap: () => controller.showEmployeeDetails(employee.id),
          );
        });
      },
    );
  }
}
