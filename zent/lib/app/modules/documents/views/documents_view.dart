import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/modules/documents/controllers/documents_controller.dart';
import '../../../data/models/file_model.dart';
import '../widgets/file_cards.dart';
import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/widgets/main_layout.dart';

class DocumentsView extends StatefulWidget {
  const DocumentsView({super.key});

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mainLayoutSearchController =
      TextEditingController();
  late final DocumentsController controller;
  String _selectedFileType = 'Todos';
  late List<String> _fileTypeFilters;

  // English to Spanish translation map
  final Map<String, String> _entityTypeTranslations = {
    'employee': 'Empleados',
    'client': 'Clientes',
    'supplier': 'Proveedores',
    'project': 'Proyectos',
    // Add more translations as needed
  };

  // Spanish to English reverse map
  late Map<String, String> _reverseTranslations;

  @override
  void initState() {
    super.initState();
    // Create the reverse translation map
    _reverseTranslations = Map.fromEntries(
      _entityTypeTranslations.entries.map((e) => MapEntry(e.value, e.key)),
    );

    // Initialize controller
    controller = Get.put(DocumentsController());
    // Initialize with default 'Todos'
    _fileTypeFilters = ['Todos'];
    // Load files from repository
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    await controller.getAllFiles();
    _updateFileTypeFilters(); // Update filters after loading files
  }

  // Updated method to translate entity types
  void _updateFileTypeFilters() {
    final Set<String> uniqueEntityTypes = controller.files
        .where((file) => file.entityType.isNotEmpty)
        .map((file) => file.entityType)
        .toSet();

    final List<String> translatedTypes = uniqueEntityTypes.map((type) {
      return _entityTypeTranslations[type] ??
          type; // Use translation or fallback to original
    }).toList();

    setState(() {
      _fileTypeFilters = ['Todos', ...translatedTypes];

      // Make sure selected filter is valid, otherwise reset to 'Todos'
      if (!_fileTypeFilters.contains(_selectedFileType)) {
        _selectedFileType = 'Todos';
      }
    });
  }

  List<FileModel> get _filteredFiles {
    return controller.files.where((file) {
      // Apply text filter
      final matchesSearch = _searchController.text.isEmpty ||
          file.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      // Apply type filter - convert Spanish back to English if needed
      final matchesType = _selectedFileType == 'Todos' ||
          file.entityType == _reverseTranslations[_selectedFileType] ||
          file.entityType == _selectedFileType;

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mainLayoutSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MainLayout(
      pageTitle: 'Documentos',
      textController: _mainLayoutSearchController,
      child: Stack(
        children: [
          Column(
            children: [
              // Filters section
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 500, // Fixed width for right-aligned filters
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Dropdown filter
                      Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFileType,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            isExpanded: true,
                            hint: const Text('Tipo de archivo'),
                            items: _fileTypeFilters.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedFileType = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text search filter
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            fillColor: theme.shadowColor.withOpacity(0),
                            hintText: 'Buscar documentos...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // File grid
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error al cargar documentos',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.errorMessage.value,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadFiles,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filteredFiles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 64,
                            color: theme.colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron documentos',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: FileCardsGrid(
                      files: _filteredFiles,
                      onFileTap: (file) {
                        // Preview file action
                        Get.snackbar(
                          'Abrir documento',
                          'Abriendo ${file.name}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      onDownload: controller.downloadFile,
                      // (file) {
                      //   Get.snackbar(
                      //     'Descargando',
                      //     'Descargando ${file.name}',
                      //     snackPosition: SnackPosition.BOTTOM,
                      //   );
                      // },
                      onDelete: controller.deleteFile,
                      // (file) {
                      //   Get.dialog(
                      //     AlertDialog(
                      //       title: const Text('Eliminar documento'),
                      //       content: Text(
                      //           '¿Estás seguro que deseas eliminar ${file.name}?'),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () => Get.back(),
                      //           child: const Text('Cancelar'),
                      //         ),
                      //         TextButton(
                      //           onPressed: () {
                      //             // Here would go the delete logic
                      //             final fileId =
                      //                 int.tryParse(file.id.toString());
                      //             if (fileId != null) {
                      //               controller.files
                      //                   .removeWhere((f) => f.id == fileId);
                      //             }
                      //             Get.back();
                      //             Get.snackbar(
                      //               'Eliminado',
                      //               'Documento eliminado exitosamente',
                      //               snackPosition: SnackPosition.BOTTOM,
                      //             );
                      //           },
                      //           child: Text(
                      //             'Eliminar',
                      //             style:
                      //                 TextStyle(color: theme.colorScheme.error),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // },
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
