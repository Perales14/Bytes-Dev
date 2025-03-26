import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/provider_model.dart';
import 'add_provider_card.dart';
import 'provider_card.dart';

class ProvidersCardsGrid extends StatelessWidget {
  final List<ProviderModel> providers;
  final VoidCallback onAddProvider;

  // Constantes de dimensiones y espaciado
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
    final width = MediaQuery.of(context).size.width;
    final availableWidth = width - (padding * 2);

    final cardsPerRow =
        ((availableWidth + spacing) / (cardWidth + spacing)).floor();

    final itemsPerRow = cardsPerRow > 0 ? cardsPerRow : 1;

    final itemCount = providers.length + 1;

    return GridView.builder(
      padding: const EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: cardWidth / cardHeight,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return AddProviderCard(onTap: onAddProvider);
        }
        final provider = providers[index - 1];

        return ProviderCard(
          provider: provider,
          onTap: () => Get.toNamed('/providers/${provider.id}'),
        );
      },
    );
  }
}
