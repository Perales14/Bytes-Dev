import 'package:flutter/material.dart';
import '../../../shared/widgets/add_entity_card.dart';

class AddProviderCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddProviderCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AddEntityCard(
      labelText: 'Agregar Proveedor',
      onTap: onTap,
    );
  }
}
