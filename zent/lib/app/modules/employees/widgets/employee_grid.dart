import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import '../../../modules/users/widgets/user_card.dart';
import '../controllers/employees_controller.dart';

class EmployeeGrid extends GetWidget<EmployeesController> {
  final List<UsuarioModel> employees;

  const EmployeeGrid({
    super.key,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal card width
        double cardWidth = 280.0; // Base card width
        int crossAxisCount = constraints.maxWidth ~/ cardWidth;

        // Ensure at least one column and handle special cases
        crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

        // Special handling for small number of cards
        if (employees.length == 1) {
          // If only one card, take half the width
          return _buildSingleCard(constraints.maxWidth / 2);
        } else if (employees.length == 2 && crossAxisCount >= 2) {
          // If two cards and enough space, each takes half
          return _buildTwoCards(constraints.maxWidth / 2);
        }

        // Normal grid for 3+ cards or when space is limited
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: cardWidth / 140, // Width divided by height
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return UserCard(
              user: employee,
              projectCount: controller.getProjectCount(employee.id),
              taskCount: controller.getTaskCount(employee.id),
              onTap: () => controller.onEmployeeSelected(employee),
            );
          },
        );
      },
    );
  }

  // Special layout for a single card centered with half width
  Widget _buildSingleCard(double width) {
    final employee = employees.first;

    return Center(
      child: SizedBox(
        width: width,
        child: UserCard(
          user: employee,
          projectCount: controller.getProjectCount(employee.id),
          taskCount: controller.getTaskCount(employee.id),
          onTap: () => controller.onEmployeeSelected(employee),
        ),
      ),
    );
  }

  // Special layout for exactly two cards
  Widget _buildTwoCards(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          child: UserCard(
            user: employees[0],
            projectCount: controller.getProjectCount(employees[0].id),
            taskCount: controller.getTaskCount(employees[0].id),
            onTap: () => controller.onEmployeeSelected(employees[0]),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: width,
          child: UserCard(
            user: employees[1],
            projectCount: controller.getProjectCount(employees[1].id),
            taskCount: controller.getTaskCount(employees[1].id),
            onTap: () => controller.onEmployeeSelected(employees[1]),
          ),
        ),
      ],
    );
  }
}
