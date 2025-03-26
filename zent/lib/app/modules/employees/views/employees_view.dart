import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/employees_controller.dart';
import '../widgets/employees_cards_grid.dart';
import '../widgets/add_employee_dialog.dart';

class EmployeesView extends GetView<EmployeesController> {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      // Corregido el nombre del controlador de texto
      textController: controller.textController,
      pageTitle: 'Empleados',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),

            // Contenido principal con grid de tarjetas
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value) {
                  return _buildErrorState();
                }

                if (controller.employeesEmpty()) {
                  return _buildEmptyState();
                }

                // Usamos directamente los employees filtrados del controlador
                return EmployeesCardsGrid(
                  employees: controller.empleadosFiltrados(),
                  controller: controller,
                  onAddEmployee: () => _showAddEmployeeDialog(context),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return AddEmployeeDialog(
          onSaveSuccess: () => controller.refreshData(),
        );
      },
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
