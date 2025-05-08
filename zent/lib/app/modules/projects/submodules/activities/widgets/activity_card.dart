import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/activity_model.dart';

/// Widget que representa una tarjeta de actividad en el tablero Kanban
class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final String? managerName;
  final Function()? onTap;
  final Function()? onLongPress;

  const ActivityCard({
    super.key,
    required this.activity,
    this.managerName,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getBorderColor(),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la actividad
              Text(
                activity.title ?? 'Sin título',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Descripción
              Text(
                activity.description,
                style: Get.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Fechas y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Fecha de inicio y fin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateRow(
                          label: 'Inicio:',
                          date: activity.startDate,
                          icon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: 4),
                        _buildDateRow(
                          label: 'Fin:',
                          date: activity.endDate,
                          icon: Icons.event_outlined,
                          isEndDate: true,
                        ),
                      ],
                    ),
                  ),

                  // Indicador si está atrasada
                  if (_isOverdue())
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Atrasada',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Responsable
              if (managerName != null)
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Get.theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        managerName!,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Get.theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para mostrar fechas con formato
  Widget _buildDateRow({
    required String label,
    DateTime? date,
    required IconData icon,
    bool isEndDate = false,
  }) {
    final formattedDate =
        date != null ? '${date.day}/${date.month}/${date.year}' : 'No definida';

    final isOverdue = isEndDate && _isOverdue();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: isOverdue ? Colors.red : Get.theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '$label ',
          style: Get.textTheme.bodySmall,
        ),
        Text(
          formattedDate,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isOverdue ? Colors.red : null,
          ),
        ),
      ],
    );
  }

  // Determina si la actividad está atrasada
  bool _isOverdue() {
    if (activity.endDate == null) return false;
    if (_getStateText() == 'Finalizada') return false;

    return DateTime.now().isAfter(activity.endDate!);
  }

  // Obtiene el color del borde según el estado
  Color _getBorderColor() {
    switch (activity.stateId) {
      case 1: // SIN COMENZAR
        return Colors.grey;
      case 2: // EN PROGRESO
        return Colors.blue;
      case 3: // FINALIZADA
        return Colors.green;
      case 4: // CANCELADA
        return Colors.orange;
      case 5: // ARCHIVADA
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Obtiene el texto del estado
  String _getStateText() {
    switch (activity.stateId) {
      case 1:
        return 'Sin comenzar';
      case 2:
        return 'En progreso';
      case 3:
        return 'Finalizada';
      case 4:
        return 'Cancelada';
      case 5:
        return 'Archivada';
      default:
        return 'Desconocido';
    }
  }
}
