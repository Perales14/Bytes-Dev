import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarUserHeader extends StatelessWidget {
  final String userName;
  final String? userRole;
  final String? userImageUrl;

  const SidebarUserHeader({
    super.key,
    required this.userName,
    this.userRole,
    this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores dinámicos según el tema
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = isDark
        ? theme.colorScheme.onSurface.withOpacity(0.7)
        : theme.colorScheme.onSurface.withOpacity(0.6);

    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto de perfil (o placeholder)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.8),
              image: userImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(userImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: userImageUrl == null
                ? Icon(Icons.person, color: Colors.white, size: 24)
                : null,
          ),

          const SizedBox(width: 12),

          // Nombre y rol del usuario
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.headlineMedium!.copyWith(
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (userRole != null)
                  Text(
                    userRole!,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
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
