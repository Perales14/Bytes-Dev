import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../cards/compact_project_card.dart';

/// Sección que muestra los proyectos más recientes en una lista
class RecentProjectsSection extends StatelessWidget {
  final HomeController controller;

  const RecentProjectsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProjectsList(),
          _buildFooter(), // Reemplazado header por footer
        ],
      ),
    );
  }

  /// Construye el pie de página de la sección con título discreto
  Widget _buildFooter() {
    return Container(
      color: const Color.fromARGB(255, 49, 63, 85).withOpacity(0.85),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centrado para mayor elegancia
        children: [
          Text(
            'Proyectos Recientes',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70, // Color más sutil
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de proyectos con manejo de estados de carga y vacío
  Widget _buildProjectsList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingIndicator();
        }

        if (controller.recentProjects.isEmpty) {
          return _buildEmptyState();
        }

        final projects = controller.recentProjects.take(5).toList();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 2),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1, 
              indent: 8, 
              endIndent: 8,
            ),
            itemBuilder: (context, index) => CompactProjectCard(
              project: projects[index],
            ),
          ),
        );
      }),
    );
  }

  /// Indicador de carga cuando se están obteniendo los datos
  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  /// Estado vacío cuando no hay proyectos para mostrar
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_off, size: 24, color: Colors.grey),
          SizedBox(height: 4),
          Text(
            'No hay proyectos recientes',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
