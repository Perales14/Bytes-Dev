import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/file_model.dart';
import '../../../data/models/observation_model.dart';
import '../../../data/services/observation_service.dart';
import '../../../data/services/file_service.dart';
import '../controllers/employee_details_controller.dart';
import '../../../data/models/user_model.dart';
import '../controllers/employees_controller.dart';
import 'add_employee_dialog.dart';
import '../../../shared/widgets/detail_action_button.dart';

class EmployeeDetailsDialog extends StatefulWidget {
  final UserModel employee;
  final VoidCallback? onEditPressed;
  final VoidCallback? onClose;

  const EmployeeDetailsDialog({
    super.key,
    required this.employee,
    this.onEditPressed,
    this.onClose,
  });

  @override
  State<EmployeeDetailsDialog> createState() => _EmployeeDetailsDialogState();
}

class _EmployeeDetailsDialogState extends State<EmployeeDetailsDialog> {
  late final EmployeeDetailsController _detailsController;
  final RxList<ObservationModel> observations = <ObservationModel>[].obs;
  final RxBool isLoadingObs = true.obs;
  final TextEditingController _newObservationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailsController = Get.put(
      EmployeeDetailsController(employeeId: widget.employee.id),
      tag: 'employee_details_${widget.employee.id}',
    );

    _loadObservations();

    ever(_detailsController.files, (_) {
      print(
          'Files changed in detailsController: ${_detailsController.files.length}');
    });
  }

  Future<void> _loadObservations() async {
    try {
      isLoadingObs.value = true;
      final result =
          await Get.find<ObservationService>().getObservationsBySource(
        'employees',
        widget.employee.id,
      );

      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      observations.assignAll(result);
    } catch (_) {
      // Manejo silencioso de errores
    } finally {
      isLoadingObs.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return RawKeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape &&
            Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.05,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 900,
              maxHeight: size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderSection(theme),
                    const SizedBox(height: 36),
                    _buildEmployeeDataSection(theme),
                    const SizedBox(height: 24),
                    _buildContactSection(theme),
                    const SizedBox(height: 24),
                    _buildObservationsSection(theme),
                    const SizedBox(height: 24),
                    _buildFilesSection(theme),
                    const SizedBox(height: 36),
                    _buildFooterSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Secciones principales del diálogo
  Widget _buildHeaderSection(ThemeData theme) {
    return Row(
      children: [
        const Spacer(),
        Text(
          'Información del Empleado',
          style: theme.textTheme.headlineMedium,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Cerrar',
        ),
      ],
    );
  }

  Widget _buildEmployeeDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Datos Personales'),
        const SizedBox(height: 16),
        _buildInfoRow(theme, 'Nombre completo:',
            '${widget.employee.name} ${widget.employee.fatherLastName} ${widget.employee.motherLastName ?? ""}'),
        _buildInfoRow(theme, 'Correo electrónico:', widget.employee.email),
        _buildInfoRow(theme, 'NSS:', widget.employee.socialSecurityNumber),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Información Laboral'),
        const SizedBox(height: 16),
        _buildInfoRow(theme, 'Fecha de ingreso:',
            widget.employee.entryDate.toString().split(' ')[0]),
        _buildInfoRow(
            theme, 'Teléfono:', widget.employee.phoneNumber ?? 'No disponible'),
        _buildInfoRow(
            theme,
            'Rol:',
            Get.find<EmployeesController>()
                .getRoleName(widget.employee.roleId)),
        _buildInfoRow(theme, 'Tipo de contrato:',
            widget.employee.contractType ?? 'No especificado'),
        _buildInfoRow(
            theme,
            'Salario:',
            widget.employee.salary != null
                ? '\$${widget.employee.salary}'
                : 'No especificado'),
        if (widget.employee.department != null)
          _buildInfoRow(theme, 'Departamento:', widget.employee.department!),
      ],
    );
  }

  // Sección de observaciones
  Widget _buildObservationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddObservationForm(theme),
              Divider(
                color: theme.colorScheme.outline.withOpacity(0.5),
                height: 1,
                thickness: 1,
              ),
              _buildObservationsList(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddObservationForm(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agregar nueva observación',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _newObservationController,
                  decoration: InputDecoration(
                    hintText: 'Escriba su observación aquí...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _addNewObservation(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_comment,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Agregar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObservationsList(ThemeData theme) {
    return Obx(() {
      if (isLoadingObs.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: observations.isEmpty
            ? Text(
                'No hay observaciones registradas para este empleado.',
                style: theme.textTheme.bodyLarge,
              )
            : SizedBox(
                height: observations.length > 6 ? 300 : null,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: observations
                        .map((obs) => _buildObservationTimelineItem(theme, obs))
                        .toList(),
                  ),
                ),
              ),
      );
    });
  }

  Widget _buildObservationTimelineItem(ThemeData theme, ObservationModel obs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (observations.indexOf(obs) != observations.length - 1)
                Container(
                  width: 2,
                  height: 55,
                  color: theme.colorScheme.primary.withOpacity(0.5),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.find<ObservationService>()
                              .getFormattedCreationDate(obs),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          obs.observation,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        margin: const EdgeInsets.only(right: 12),
                        child: ElevatedButton(
                          onPressed: () => _showEditObservationDialog(obs),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 2,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 34,
                        width: 34,
                        child: ElevatedButton(
                          onPressed: () => _showDeleteObservationDialog(obs),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 2,
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gestión de observaciones
  void _addNewObservation() async {
    final text = _newObservationController.text.trim();
    if (text.isEmpty) return;

    try {
      await Get.find<ObservationService>().addQuickObservation(
        sourceTable: 'employees',
        sourceId: widget.employee.id,
        text: text,
        userId: 1, // ID del usuario actual
      );

      _newObservationController.clear();
      _loadObservations();

      Get.snackbar(
        'Éxito',
        'Observación agregada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar la observación: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  void _showEditObservationDialog(ObservationModel observation) {
    final TextEditingController controller =
        TextEditingController(text: observation.observation);

    Get.dialog(
      AlertDialog(
        title: const Text('Editar observación'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Modifique su observación',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Get.theme.colorScheme.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                try {
                  await Get.find<ObservationService>().updateObservation(
                    observation.copyWith(observation: text),
                  );
                  Get.back();
                  _loadObservations();

                  Get.snackbar(
                    'Éxito',
                    'Observación actualizada correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'No se pudo actualizar la observación: $e',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Get.theme.colorScheme.error,
                    colorText: Get.theme.colorScheme.onError,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.primary,
              foregroundColor: Get.theme.colorScheme.onPrimary,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteObservationDialog(ObservationModel observation) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar observación'),
        content: const Text(
            '¿Está seguro que desea eliminar esta observación? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Get.theme.colorScheme.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Get.find<ObservationService>()
                    .deleteObservation(observation.id);
                Get.back();
                _loadObservations();

                Get.snackbar(
                  'Éxito',
                  'Observación eliminada correctamente',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'No se pudo eliminar la observación: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.colorScheme.error,
                  colorText: Get.theme.colorScheme.onError,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.error,
              foregroundColor: Get.theme.colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // Sección de archivos
  Widget _buildFilesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Documentos'),
        const SizedBox(height: 16),
        _buildFilesTable(theme),
      ],
    );
  }

  Widget _buildFilesTable(ThemeData theme) {
    final controller = Get.find<EmployeeDetailsController>(
      tag: 'employee_details_${widget.employee.id}',
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Archivos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showUploadFileDialog(context, controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.upload_file,
                    size: 18, color: Get.theme.colorScheme.onPrimary),
                label: const Text('Subir documento'),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.isLoadingFiles.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.files.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No hay archivos disponibles para este empleado',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildFilesTableHeader(theme),
                ...controller.files
                    .map((file) => _buildFileRow(theme, file, controller)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFilesTableHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Nombre del archivo',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Tamaño',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Fecha',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildFileRow(
      ThemeData theme, FileModel file, EmployeeDetailsController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _getFileIcon(file.type, theme),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      file.name,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                file.formattedSize,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                _formatDate(file.uploadDate),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  tooltip: 'Descargar archivo',
                  onPressed: () => controller.downloadFile(file),
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar archivo',
                  onPressed: () => controller.deleteFile(file),
                  iconSize: 20,
                  color: theme.colorScheme.error,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadFileDialog(
      BuildContext context, EmployeeDetailsController controller) async {
    try {
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Seleccionando archivo...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final fileService = Get.find<FileService>();
      final success = await fileService.uploadFileWithFilePicker(
        entityId: widget.employee.id,
        entityType: 'employee',
        onFileSelected: () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }

          Get.dialog(
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Subiendo archivo...'),
                    ],
                  ),
                ),
              ),
            ),
            barrierDismissible: false,
          );
        },
      );

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (success) {
        Get.snackbar(
          'Éxito',
          'Archivo subido correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );

        await controller.loadFiles();
        controller.update();
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'No se pudo subir el archivo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Elementos comunes y de utilidad
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Divider(color: theme.colorScheme.primary.withOpacity(0.5)),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    final displayValue = value.isEmpty ? 'No disponible' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DetailActionButton(
          type: DetailActionType.edit,
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
            Get.find<EmployeesController>()
                .showEditEmployeeDialog(widget.employee.id);
          },
        ),
        const SizedBox(width: 60),
        DetailActionButton(
          type: DetailActionType.delete,
          onPressed: () async {
            try {
              await Get.find<EmployeesController>()
                  .setEmployeeInactive(widget.employee.id);
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              if (widget.onClose != null) {
                widget.onClose!();
              }
              Get.find<EmployeesController>().refreshData();
            } catch (e) {
              Get.snackbar(
                'Error',
                'No se pudo desactivar el empleado: $e',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError,
              );
            }
          },
          isOutlined: true,
          customText: 'Desactivar',
          confirmationTitle: 'Desactivar empleado',
          confirmationMessage:
              '¿Está seguro que desea desactivar este empleado? Podrá reactivarlo posteriormente.',
        ),
      ],
    );
  }

  Widget _getFileIcon(String type, ThemeData theme) {
    IconData iconData;
    Color color;

    type = type.toLowerCase();

    if (type.contains('pdf')) {
      iconData = Icons.picture_as_pdf;
      color = Colors.red;
    } else if (type.contains('image') ||
        type.contains('jpg') ||
        type.contains('png')) {
      iconData = Icons.image;
      color = Colors.blue;
    } else if (type.contains('doc')) {
      iconData = Icons.description;
      color = Colors.blue.shade800;
    } else if (type.contains('xls')) {
      iconData = Icons.table_chart;
      color = Colors.green;
    } else {
      iconData = Icons.insert_drive_file;
      color = Colors.grey;
    }

    return Icon(iconData, size: 20, color: color);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _newObservationController.dispose();
    if (widget.onClose != null) {
      widget.onClose!();
    }
    super.dispose();
  }
}
