import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/widgets/entity_card.dart';

class EmployeesCard extends StatelessWidget {
  final String name;
  final String position;
  final String role;
  final int projectCount;
  final int taskCount;
  final VoidCallback? onTap;

  const EmployeesCard({
    super.key,
    required this.name,
    required this.position,
    required this.role,
    this.projectCount = 0,
    this.taskCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return EntityCard(
      data: EntityCardData(
        title: name,
        description: position,
        badgeText: role,
        onTap: onTap,
        counters: [
          EntityCardCounter(
            icon: Icons.folder_outlined,
            count: projectCount.toString(),
          ),
          EntityCardCounter(
            icon: Icons.task_alt_outlined,
            count: taskCount.toString(),
          ),
          // EntityCardCounter(
          //   icon: Icons.edit,
          //   count: '',
          // ),
        ],
      ),
    );
  }
}

// Ejemplo de uso:
class EmployeesCardExample extends StatelessWidget {
  const EmployeesCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeesCard(
      name: "Juan Pérez",
      position: "Desarrollador Frontend",
      role: "Empleado",
      projectCount: 2,
      taskCount: 5,
      onTap: () => print("Card tapped"),
    );
  }
}
