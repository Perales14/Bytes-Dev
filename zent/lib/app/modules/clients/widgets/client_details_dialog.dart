import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/cliente_model.dart';
import '../../../data/models/observacion_model.dart';
import '../../../data/repositories/observacion_repository.dart';

class ClientDetailsDialog extends StatefulWidget {
  final ClienteModel client;
  final VoidCallback? onEditPressed;

  const ClientDetailsDialog({
    super.key,
    required this.client,
    this.onEditPressed,
  });

  @override
  State<ClientDetailsDialog> createState() => _ClientDetailsDialogState();
}

class _ClientDetailsDialogState extends State<ClientDetailsDialog> {
  final ObservacionRepository _observacionRepository =
      Get.find<ObservacionRepository>();
  final RxList<ObservacionModel> observaciones = <ObservacionModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _cargarObservaciones();
  }

  Future<void> _cargarObservaciones() async {
    try {
      isLoading.value = true;
      final result = await _observacionRepository.getByOrigen(
          'clientes', widget.client.id);
      observaciones.assignAll(result);
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar observaciones: $e');
      }
    } finally {
      isLoading.value = false;
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
                    // Título con botón de cerrar
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          'Información del Cliente',
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

                    // Sección: Datos Personales
                    _buildSectionTitle(theme, 'Datos Personales'),
                    const SizedBox(height: 16),

                    // Nombre completo
                    _buildInfoRow(
                        theme,
                        'Nombre completo:',
                        '${widget.client.nombre} ${widget.client.apellidoPaterno} ${widget.client.apellidoMaterno ?? ""}'
                            .trim()),

                    // Nombre de empresa (movido desde Datos Empresariales)
                    if (widget.client.nombreEmpresa != null &&
                        widget.client.nombreEmpresa!.isNotEmpty)
                      _buildInfoRow(
                          theme, 'Empresa:', widget.client.nombreEmpresa!),

                    // RFC (movido desde Datos Empresariales)
                    if (widget.client.rfc != null &&
                        widget.client.rfc!.isNotEmpty)
                      _buildInfoRow(theme, 'RFC:', widget.client.rfc!),

                    // Correo electrónico
                    _buildInfoRow(theme, 'Correo electrónico:',
                        widget.client.email ?? 'No disponible'),

                    // Teléfono
                    _buildInfoRow(theme, 'Teléfono:',
                        widget.client.telefono ?? 'No disponible'),

                    // Tipo de cliente
                    _buildInfoRow(theme, 'Tipo de cliente:',
                        _formatClientType(widget.client.tipo)),
                    if (widget.client.tipo == 'empresa')
                      _buildInfoRow(theme, 'Empresa:',
                          widget.client.nombreEmpresa ?? 'No disponible'),
                    const SizedBox(height: 24),

                    // Sección: Observaciones
                    _buildSectionTitle(theme, 'Observaciones'),
                    const SizedBox(height: 16),

                    // Observaciones
                    Obx(() {
                      if (isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (observaciones.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    theme.colorScheme.outline.withOpacity(0.3)),
                          ),
                          child: Text(
                            'No hay observaciones registradas para este cliente.',
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  theme.colorScheme.outline.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: observaciones.map((obs) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    obs.observacion,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Text(
                                    _formatDate(obs.createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  if (observaciones.last != obs)
                                    Divider(
                                      color: theme.colorScheme.outline
                                          .withOpacity(0.2),
                                      height: 16,
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),

                    const SizedBox(height: 36),

                    // Botón para editar
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: widget.onEditPressed,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${_formatTimeDigit(date.hour)}:${_formatTimeDigit(date.minute)}';
  }

  String _formatTimeDigit(int digit) {
    return digit.toString().padLeft(2, '0');
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

  // Formatea el tipo de cliente para mostrarlo correctamente
  String _formatClientType(String? tipo) {
    if (tipo == null || tipo.isEmpty) {
      return 'Regular';
    }

    // Capitaliza la primera letra
    return tipo[0].toUpperCase() + tipo.substring(1);
  }
}
