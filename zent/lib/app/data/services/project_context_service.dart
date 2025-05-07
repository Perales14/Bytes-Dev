import 'package:get/get.dart';
import '../models/project_model.dart';

/// Servicio para compartir contexto de proyecto entre submódulos
///
/// Este servicio permite compartir información del proyecto activo
/// entre diferentes submódulos sin tener que pasar argumentos entre rutas.
class ProjectContextService extends GetxService {
  // Proyecto actualmente seleccionado
  final Rx<ProjectModel?> _currentProject = Rx<ProjectModel?>(null);

  // Getter para el proyecto actual
  ProjectModel? get currentProject => _currentProject.value;

  // Observable para reaccionar a cambios en el proyecto actual
  Rx<ProjectModel?> get rxCurrentProject => _currentProject;

  /// Establece el proyecto activo
  void setCurrentProject(ProjectModel project) {
    _currentProject.value = project;
  }

  /// Limpia el proyecto activo
  void clearCurrentProject() {
    _currentProject.value = null;
  }
}
