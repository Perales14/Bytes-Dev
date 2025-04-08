import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/widgets/add_entity_card.dart';

class AddProjectCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddProjectCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AddEntityCard(
      labelText: 'Agregar Empleado',
      onTap: onTap,
    );
  }
}
