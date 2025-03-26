import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/provider_model.dart';
import '../../../shared/widgets/entity_card.dart';
import '../controllers/providers_controller.dart';

class ProviderCard extends GetWidget<ProvidersController> {
  final ProviderModel provider;
  final VoidCallback onTap;

  const ProviderCard({
    required this.provider,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Asegurar que la especialidad está cargada
    controller.loadSpecialtyIfNeeded(provider.specialtyId);

    // Usar Obx para reactividad
    return Obx(() {
      final specialty = controller.getSpecialtyName(provider.specialtyId);

      return EntityCard(
        data: EntityCardData(
          title: provider.companyName,
          description: provider.mainContactName ?? 'Sin contacto',
          badgeText: specialty,
          // Usamos el método showProviderDetails para mostrar el diálogo
          onTap: () => controller.showProviderDetails(provider.id),
          counters: [
            // EntityCardCounter(
            //   icon: Icons.payments_outlined,
            //   count: provider.paymentTerms ?? '-',
            // ),
            EntityCardCounter(
              icon: Icons.category_outlined,
              count: provider.serviceType ?? '-',
            ),
          ],
        ),
      );
    });
  }
}
