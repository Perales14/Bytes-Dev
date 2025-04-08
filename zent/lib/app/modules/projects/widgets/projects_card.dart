import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/widgets/entity_card.dart';

class ProjectsCard extends StatelessWidget {
  final String name;
  final String position;
  final String role;
  final int projectCount;
  final int taskCount;
  final VoidCallback? onTap;

  const ProjectsCard({
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
class ProjectsCardExample extends StatelessWidget {
  const ProjectsCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ProjectsCard(
      name: "Juan Pérez",
      position: "Desarrollador Frontend",
      role: "Empleado",
      projectCount: 2,
      taskCount: 5,
      onTap: () => print("Card tapped"),
    );
  }
}
