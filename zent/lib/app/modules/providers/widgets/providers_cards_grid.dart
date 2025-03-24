import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/proveedor_model.dart';
import 'provider_card.dart';

class ProvidersCardsGrid extends StatelessWidget {
  final List<ProveedorModel> providers;
  final Function onAddProvider;

  const ProvidersCardsGrid({
    required this.providers,
    required this.onAddProvider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen ? 1 : 3,
        childAspectRatio: isSmallScreen ? 2 : 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: providers.length + 1, // +1 para la tarjeta de añadir
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildAddCard(context);
        }

        final provider = providers[index - 1];
        return ProviderCard(
          provider: provider,
          onTap: () => Get.toNamed('/providers/${provider.id}'),
        );
      },
    );
  }

  Widget _buildAddCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () => onAddProvider(),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Agregar Proveedor',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
