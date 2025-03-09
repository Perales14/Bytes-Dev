import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/main_layout.dart';
import '../controllers/employees_controller.dart';
import '../widgets/employee_table.dart';

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
            // Header con título y botones de acción
            _buildHeader(context),

            const SizedBox(height: 24),

            // Tabla de empleados con manejo de estados
            Expanded(
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

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: EmployeesTable(employees: controller.employees), // Pasa la lista de empleados
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Directorio de empleados',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        FilledButton.icon(
          onPressed: () => Get.toNamed('/employees/add'),
          icon: const Icon(Icons.add),
          label: const Text('Nuevo empleado'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay empleados registrados',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea un nuevo empleado para comenzar',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Get.toNamed('/employees/add'),
            icon: const Icon(Icons.add),
            label: const Text('Crear empleado'),
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
            size: 64,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar empleados',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage.value,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => controller.refreshData(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
