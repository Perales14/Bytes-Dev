import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_details_controller.dart';
import '../../../shared/models/form_config.dart';

class EmployeeDetailsView extends GetView<EmployeeDetailsController> {
  const EmployeeDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Empleado'),
        centerTitle: true,
        actions: [
          /*IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/employees/${controller.employeeId}/edit'),
            tooltip: 'Editar información',
          ) */
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final employee = controller.formController.model;
        
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 900,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Center(
                    child: Text(
                      'Información del Empleado',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 36),
                  
                  // Sección: Datos Personales
                  _buildSectionTitle(theme, 'Datos Personales'),
                  const SizedBox(height: 16),
                  
                  // Nombre completo
                  _buildInfoRow(
                    theme, 
                    'Nombre completo:', 
                    '${employee.nombre} ${employee.apellidoPaterno} ${employee.apellidoMaterno}'
                  ),
                  
                  // Correo electrónico
                  _buildInfoRow(theme, 'Correo electrónico:', employee.correo),
                  
                  // Teléfono
                  _buildInfoRow(theme, 'Teléfono:', employee.telefono),
                  
                  // NSS
                  _buildInfoRow(theme, 'NSS:', employee.nss),
                  
                  const SizedBox(height: 24),
                  
                  // Sección: Datos Laborales
                  _buildSectionTitle(theme, 'Datos Laborales'),
                  const SizedBox(height: 16),
                  
                  // Fecha de registro
                  _buildInfoRow(theme, 'Fecha de registro:', employee.fechaRegistro),
                  
                  // Rol
                  _buildInfoRow(theme, 'Rol:', _getRolName(employee.rol)),
                  
                  // Tipo de contrato
                  _buildInfoRow(theme, 'Tipo de contrato:', employee.tipoContrato),
                  
                  // Salario
                  _buildInfoRow(theme, 'Salario:', '\$${employee.salario}'),
                  
                  // Observaciones (si hay)
                  if (employee.observaciones.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle(theme, 'Observaciones'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                      ),
                      child: Text(
                        employee.observaciones,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 36),
                  
                  // Botón para editar
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () /*=> Get.toNamed('/employees/${controller.employeeId}/edit')*/ {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar información'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ), 
                ],
              ),
            ),
          ),
        );
      }),
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
    // Si el valor es vacío, mostrar un texto predeterminado
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
  
  String _getRolName(String rolId) {
    switch (rolId) {
      case '1': return 'Admin';
      case '2': return 'Captador de Campo';
      case '3': return 'Promotor';
      case '4': return 'Recursos Humanos';
      default: return 'Desconocido';
    }
  }
}