import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/proveedor_model.dart';
import '../../../shared/widgets/entity_card.dart';
import '../controllers/providers_controller.dart';

class ProviderCard extends GetWidget<ProvidersController> {
  final ProveedorModel provider;
  final VoidCallback onTap;

  const ProviderCard({
    required this.provider,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Asegurar que la especialidad está cargada
    controller.loadEspecialidadIfNeeded(provider.especialidadId);

    // Usar Obx para reactividad
    return Obx(() {
      final especialidad =
          controller.getEspecialidadNombre(provider.especialidadId);

      return EntityCard(
        data: EntityCardData(
          title: provider.nombreEmpresa,
          description: provider.contactoPrincipal ?? 'Sin contacto',
          badgeText: especialidad,
          // Usamos el método showProviderDetails para mostrar el diálogo
          onTap: () => controller.showProviderDetails(provider.id),
          counters: [
            // EntityCardCounter(
            //   icon: Icons.payments_outlined,
            //   count: provider.condicionesPago ?? '-',
            // ),
            EntityCardCounter(
              icon: Icons.category_outlined,
              count: provider.tipoServicio ?? '-',
            ),
          ],
        ),
      );
    });
  }
}
