import 'package:flutter/material.dart';
import '../../../data/models/usuario_model.dart';
import '../../../shared/widgets/entity_card_widget.dart';

class UserCard extends StatelessWidget {
  final UsuarioModel user;
  final Function()? onTap;
  final int projectCount;
  final int taskCount;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.projectCount = 0,
    this.taskCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return EntityCardWidget<UsuarioModel>(
      entity: user,
      badgeTextBuilder: (user) => user.tipoContrato ?? 'Sin rol',
      titleBuilder: (user) => user.nombreCompleto,
      descriptionBuilder: (user) => user.cargo ?? user.email,
      leftCounterValue: projectCount,
      rightCounterValue: taskCount,
      onTap: onTap,
    );
  }
}
