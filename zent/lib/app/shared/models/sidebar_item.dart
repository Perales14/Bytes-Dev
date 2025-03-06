import 'package:flutter/material.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final String routeName; // La ruta a la que navega
  final List<String>?
      roles; // Lista de roles que pueden ver este item (opcional)
  final bool isStatic; // Indica si es un elemento estático del sidebar

  SidebarItem({
    required this.icon,
    required this.label,
    required this.routeName,
    this.roles, // Ahora es opcional
    this.isStatic = false, // Por defecto no es estático
  });

  // Método para verificar si el ítem es visible para un rol específico
  bool isVisibleForRole(String userRole) {
    // Si no hay restricción de roles, es visible para todos
    if (roles == null || roles!.isEmpty) {
      return true;
    }

    // Verificar si el rol del usuario está en la lista de roles permitidos
    return roles!.contains(userRole.toLowerCase());
  }

  // Clone método para crear una copia con cambios opcionales
  SidebarItem copyWith({
    IconData? icon,
    String? label,
    String? routeName,
    List<String>? roles,
    bool? isStatic,
  }) {
    return SidebarItem(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      routeName: routeName ?? this.routeName,
      roles: roles ?? this.roles,
      isStatic: isStatic ?? this.isStatic,
    );
  }
}
