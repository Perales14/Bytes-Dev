import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/core/theme/app_theme.dart'; // Asegúrate de que la ruta sea correcta

class SidebarUserHeader extends StatelessWidget {
  final String userName; // Nombre del usuario
  final String? userRole; // Rol del usuario (opcional)
  final String? userImageUrl; // URL de la imagen de perfil (opcional)

  const SidebarUserHeader({
    super.key,
    required this.userName,
    this.userRole,
    this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppTheme>()!.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 16), // Padding consistente
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto de perfil (o placeholder)
          Container(
            width: 40, // Tamaño fijo para la imagen
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Imagen circular
              color: colors.tealBlue80, // Color de fondo (ajústalo)
              image: userImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(userImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null, // Muestra la imagen solo si la URL existe
            ),
            child: userImageUrl == null
                ? Icon(Icons.person, color: colors.white, size: 24)
                : null, // Icono si no hay imagen
          ),

          const SizedBox(width: 12), // Espacio entre la imagen y el texto

          // Nombre y rol del usuario
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinea el texto a la izquierda
              children: [
                Text(
                  userName,
                  style: textTheme.headlineMedium!.copyWith(
                      color: Get.isDarkMode ? colors.greyF2 : colors.black),
                  overflow: TextOverflow.ellipsis, // Evita desbordamiento
                ),
                if (userRole != null) // Muestra el rol solo si existe
                  Text(
                    userRole!,
                    style: textTheme.bodyMedium!.copyWith(
                        color: Get.isDarkMode
                            ? colors.greyF2.withOpacity(0.7)
                            : colors.black40),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
