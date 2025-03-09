import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/main_layout.dart';
import '../controllers/employees_controller.dart';
import '../widgets/add_employee_card.dart';
import '../widgets/emplooyees_card.dart';
import '../widgets/employees_table.dart';

class EmployeesView extends GetView<EmployeesController> {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      pageTitle: 'Empleados',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título
            _buildHeader(context),

            const SizedBox(height: 24),

            // Tarjetas de empleados en vista horizontal
            SizedBox(
              height: 180, // Altura fija para solucionar el error del viewport
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value) {
                  return _buildErrorState();
                }

                if (controller.employees.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    AddEmployeeCard(
                      onTap: () => Get.toNamed('/employees/add'),
                    ),
                    const SizedBox(width: 16),
                    // Aquí mostrarías las tarjetas de empleados basadas en los datos reales
                    EmployeesCard(
                      name: "Juan Pérez",
                      position: "Desarrollador Frontend",
                      role: "Empleado",
                      projectCount: 2,
                      taskCount: 5,
                      onTap: () => Get.toNamed('/employees/1'),
                    ),
                    const SizedBox(width: 16),
                    EmployeesCard(
                      name: "Ana García",
                      position: "Diseñadora UX/UI",
                      role: "Empleado",
                      projectCount: 3,
                      taskCount: 7,
                      onTap: () => Get.toNamed('/employees/2'),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 24),

            // Tabla de empleados
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value) {
                  return _buildErrorState();
                }

                if (controller.employees.isEmpty) {
                  return const Center(
                      child: Text("No hay datos para mostrar en la tabla"));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: EmployeesTable(employees: controller.employees),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Directorio de empleados',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay empleados registrados',
            style: Get.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            'Error: ${controller.errorMessage.value}',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
