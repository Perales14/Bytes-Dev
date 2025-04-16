import 'package:flutter/material.dart';

/// Modelo que representa un elemento de la barra lateral
class SidebarItem {
  final IconData icon;
  final String label;
  final String routeName;
  final List<String>? roles;
  final bool isStatic;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.routeName,
    this.roles,
    this.isStatic = false,
  });

  /// Verifica si el ítem es visible para un rol específico
  bool isVisibleForRole(String userRole) {
    // Si no hay restricción de roles, es visible para todos
    if (roles == null || roles!.isEmpty) {
      return true;
    }

    return roles!.contains(userRole.toLowerCase());
  }

  /// Crea una copia con cambios opcionales
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
