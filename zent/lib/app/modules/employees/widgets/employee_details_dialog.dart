import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/employee_details_controller.dart';
import '../../../data/models/user_model.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final UserModel employee;
  final VoidCallback? onEditPressed;

  const EmployeeDetailsDialog({
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
                    _buildInfoRow(theme, 'Rol:', _getRoleName(employee.roleId)),
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
                    const SizedBox(height: 36),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: onEditPressed,
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar información'),
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

  String _getRoleName(int roleId) {
    switch (roleId) {
      case 2:
        return 'Admin';
      case 1:
        return 'Captador de Campo';
      case 3:
        return 'Promotor';
      case 4:
        return 'Recursos Humanos';
      default:
        return 'Desconocido';
    }
  }
}
