import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cards/action_shortcut.dart';

/// Sección que muestra una cuadrícula de botones de acción rápida
/// Adaptable al espacio disponible con una distribución 2x2
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Cálculo preciso del espacio y proporciones
      final double availableHeight = constraints.maxHeight - 16;
      final double availableWidth = constraints.maxWidth - 16;

      final double itemHeight = (availableHeight / 2) - 6;
      final double itemWidth = (availableWidth / 2) - 6;

      final double aspectRatio = itemWidth / itemHeight;

      return Container(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => _buildActionItem(index),
        ),
      );
    });
  }

  /// Construye un elemento de acción según su índice
  Widget _buildActionItem(int index) {
    switch (index) {
      case 0:
        return ActionShortcut(
          icon: Icons.person_add,
          label: 'Nuevo Empleado',
          color: Colors.blue,
          onTap: () => _showActionPendingMessage('añadir empleado'),
        );
      case 1:
        return ActionShortcut(
          icon: Icons.people,
          label: 'Nuevo Cliente',
          color: Colors.green,
          onTap: () => _showActionPendingMessage('añadir cliente'),
        );
      case 2:
        return ActionShortcut(
          icon: Icons.business,
          label: 'Nuevo Proveedor',
          color: Colors.purple,
          onTap: () => _showActionPendingMessage('añadir proveedor'),
        );
      case 3:
      default:
        return ActionShortcut(
          icon: Icons.assignment,
          label: 'Nuevo Proyecto',
          color: Colors.orange,
          onTap: () => _showActionPendingMessage('añadir proyecto'),
        );
    }
  }

  /// Muestra mensaje de función en desarrollo
  void _showActionPendingMessage(String action) {
    Get.snackbar(
      'Acción pendiente',
      'Función para $action en desarrollo',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
