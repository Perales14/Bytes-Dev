import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/file_model.dart';
import '../controllers/employee_details_controller.dart';
import '../../../data/models/user_model.dart';
import '../controllers/employees_controller.dart';
import 'add_employee_dialog.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final UserModel employee;
  final VoidCallback? onEditPressed;

  // Obtener el controlador una sola vez
  final EmployeesController employeesController =
      Get.find<EmployeesController>();

  EmployeeDetailsDialog({
    super.key,
    required this.employee,
    this.onEditPressed,
  });

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
                    Row(
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
                    ),
                    const SizedBox(height: 36),
                    _buildSectionTitle(theme, 'Datos Personales'),
                    const SizedBox(height: 16),
                    _buildInfoRow(theme, 'Nombre completo:',
                        '${employee.name} ${employee.fatherLastName} ${employee.motherLastName ?? ""}'),
                    _buildInfoRow(theme, 'Correo electrónico:', employee.email),
                    _buildInfoRow(theme, 'Teléfono:',
                        employee.phoneNumber ?? 'No disponible'),
                    _buildInfoRow(theme, 'NSS:', employee.socialSecurityNumber),
                    const SizedBox(height: 24),
                    _buildSectionTitle(theme, 'Datos Laborales'),
                    const SizedBox(height: 16),
                    _buildInfoRow(theme, 'Fecha de ingreso:',
                        employee.entryDate.toString().split(' ')[0]),
                    _buildInfoRow(theme, 'Rol:',
                        employeesController.getRoleName(employee.roleId)),
                    _buildInfoRow(theme, 'Tipo de contrato:',
                        employee.contractType ?? 'No especificado'),
                    _buildInfoRow(
                        theme,
                        'Salario:',
                        employee.salary != null
                            ? '\$${employee.salary}'
                            : 'No especificado'),
                    if (employee.department != null &&
                        employee.department!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle(theme, 'Observaciones'),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  theme.colorScheme.outline.withOpacity(0.3)),
                        ),
                        child: Text(
                          employee.department!,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildSectionTitle(theme, 'Archivos del Empleado'),
                    const SizedBox(height: 16),
                    _buildFilesTable(theme),
                    const SizedBox(height: 36),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Empleado'),
                        onPressed: () {
                          // Cierra el diálogo actual
                          Navigator.of(context).pop();

                          // Muestra el diálogo de edición
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddEmployeeDialog(
                                employee: employee,
                                onSaveSuccess: () {
                                  // Refrescar datos después de guardar
                                  if (onEditPressed != null) {
                                    onEditPressed!();
                                  } else {
                                    // Si no hay callback específico, intentamos refrescar el controlador principal
                                    Get.find<EmployeesController>()
                                        .refreshData();
                                  }
                                },
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildFilesTable(ThemeData theme) {
    return GetBuilder<EmployeeDetailsController>(
      init: EmployeeDetailsController(employeeId: employee.id),
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
              // Encabezado de la tabla
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tamaño',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Fecha',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 60), // Espacio para el botón
                  ],
                ),
              ),

              // Filas de archivos
              ...controller.files
                  .map((file) => _buildFileRow(theme, file, controller)),
            ],
          ),
        );
      },
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
            SizedBox(
              width: 60,
              child: IconButton(
                icon: const Icon(Icons.download_rounded),
                tooltip: 'Descargar archivo',
                onPressed: () => controller.downloadFile(file),
              ),
            ),
          ],
        ),
      ),
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
}
