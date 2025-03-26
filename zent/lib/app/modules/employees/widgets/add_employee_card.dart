import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/widgets/add_entity_card.dart';

class AddEmployeeCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddEmployeeCard({
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
