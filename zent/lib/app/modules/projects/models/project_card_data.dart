import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';

/// Modelo para los datos que se mostrarán en una tarjeta de proyecto.
class ProjectCardData {
  /// Nombre del proyecto
  final String name;

  /// Descripción corta del proyecto
  final String description;

  /// Estado actual del proyecto (ej: "En progreso", "Completado")
  final String status;

  /// Color del estado (opcional)
  final Color? statusColor;

  /// Nombre del cliente asociado al proyecto
  final String clientName;

  /// Nombre del responsable/manager del proyecto
  final String managerName;

  /// Lista de indicadores o métricas del proyecto
  final List<ProjectMetric>? metrics;

  /// Acción a ejecutar cuando se pulsa la tarjeta
  final VoidCallback? onTap;

  /// Modelo completo del proyecto (opcional)
  final ProjectModel? project;

  /// Crea un modelo de datos para una tarjeta de proyecto.
  const ProjectCardData({
    required this.name,
    required this.description,
    required this.status,
    required this.clientName,
    required this.managerName,
    this.statusColor,
    this.metrics,
    this.onTap,
    this.project,
  });
}

/// Modelo para las métricas o indicadores mostrados en la tarjeta.
class ProjectMetric {
  /// Icono que representa la métrica
  final IconData icon;

  /// Etiqueta de la métrica
  final String label;

  /// Valor de la métrica
  final String value;

  /// Tooltip o descripción de la métrica (opcional)
  final String? tooltip;

  /// Crea un modelo de métrica para tarjetas de proyecto.
  const ProjectMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.tooltip,
  });
}
