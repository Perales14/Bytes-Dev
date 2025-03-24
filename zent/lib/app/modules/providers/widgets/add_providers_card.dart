import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/add_entity_card.dart';

class AddProvidersCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddProvidersCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AddEntityCard(
      labelText: 'Agregar Cliente',
      onTap: onTap,
    );
  }
}
