import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/proveedor_model.dart';
import 'add_provider_card.dart';
import 'provider_card.dart';

class ProvidersCardsGrid extends StatelessWidget {
  final List<ProveedorModel> providers;
  final VoidCallback onAddProvider;

  // Constantes de dimensiones - exactamente iguales que en EmployeesCardsGrid
  static const double cardWidth = 300.0;
  static const double cardHeight = 170.0;
  static const double spacing = 28.0;
  static const double padding = 28.0;

  const ProvidersCardsGrid({
    super.key,
    required this.providers,
    required this.onAddProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula cuántas tarjetas caben por fila considerando el padding
    final width = MediaQuery.of(context).size.width;
    final availableWidth = width - (padding * 2);

    // Calculamos cuántas tarjetas completas caben en el ancho disponible
    final cardsPerRow =
        ((availableWidth + spacing) / (cardWidth + spacing)).floor();

    // Garantizamos que siempre haya al menos 1 tarjeta por fila
    final itemsPerRow = cardsPerRow > 0 ? cardsPerRow : 1;

    // Total de elementos (proveedores + tarjeta de agregar)
    final itemCount = providers.length + 1;

    return GridView.builder(
      padding: const EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: cardWidth / cardHeight, // Proporción ancho/alto fija
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          // La primera posición siempre es la tarjeta para agregar
          return AddProviderCard(onTap: onAddProvider);
        }

        // Para el resto, obtenemos el proveedor de la lista
        final provider = providers[index - 1];

        return ProviderCard(
          provider: provider,
          onTap: () => Get.toNamed('/providers/${provider.id}'),
        );
      },
    );
  }
}
