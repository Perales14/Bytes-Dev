import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/clients_controller.dart';
import '../widgets/clients_cards_grid.dart';
import '../widgets/add_clients_dialog.dart';

class ClientsView extends GetView<ClientsController> {
  const ClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      textController: controller.textController,
      pageTitle: 'Clientes',
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

                return ClientsCardsGrid(
                  clients: controller.filteredClients(),
                  onAddClient: () => _showAddClientDialog(context),
                  controller: controller,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return AddClientsDialog(
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
            Icons.business_outlined,
            size: 48,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay clientes registrados',
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
