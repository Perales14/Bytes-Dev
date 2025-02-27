import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/core/theme/app_theme.dart'; // Asegúrate de tener la ruta correcta
import 'package:zent/models/sidebar_item.dart'; // Importa el modelo

class SidebarButton extends StatelessWidget {
  final SidebarItem item; // Usamos el modelo
  final bool isSelected; // Para resaltar el botón activo
  final VoidCallback onPressed;

  const SidebarButton({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).extension<AppTheme>()!.colors; // Accede a los colores
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 180,
      height: 36,
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: isSelected
            ? colors.tealBlue.withOpacity(0.1)
            : Colors.transparent, // Color de fondo si está seleccionado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        // Usamos InkWell para el efecto visual al tocar
        onTap: onPressed,
        borderRadius:
            BorderRadius.circular(12), // Aplica el radio a InkWell también
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: isSelected
                    ? colors.tealBlue
                    : colors.black60, // Color del icono
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.label,
                style: textTheme.headlineMedium!.copyWith(
                  // Usamos un estilo de texto definido
                  color: isSelected
                      ? colors.tealBlue
                      : colors.black, // Color del texto
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w500, // Negrita si está seleccionado
                ),
                overflow:
                    TextOverflow.ellipsis, // Evita desbordamiento de texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
