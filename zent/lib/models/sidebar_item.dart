import 'package:flutter/material.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final String routeName; // La ruta a la que navega
  final List<String> roles; // Lista de roles que pueden ver este item

  SidebarItem({
    required this.icon,
    required this.label,
    required this.routeName,
    required this.roles,
  });
}
