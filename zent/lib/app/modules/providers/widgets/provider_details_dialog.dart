import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/provider_model.dart';
import '../../../data/models/observation_model.dart';
import '../../../data/services/observation_service.dart';
import '../../../data/services/address_service.dart';
import '../../../data/models/address_model.dart';
import '../../../shared/widgets/detail_action_button.dart';
import '../controllers/providers_controller.dart';

class ProviderDetailsDialog extends StatefulWidget {
  final ProviderModel provider;
  final VoidCallback? onEditPressed;
  final VoidCallback? onClose; // Nuevo callback para notificar cierre

  const ProviderDetailsDialog({
    super.key,
    required this.provider,
    this.onEditPressed,
    this.onClose,
  });

  @override
  State<ProviderDetailsDialog> createState() => _ProviderDetailsDialogState();
}

class _ProviderDetailsDialogState extends State<ProviderDetailsDialog> {
  // Servicios
  late final ObservationService _observationService;
  late final AddressService _addressService;
  late final ProvidersController _providersController;

  // Variables reactivas
  final RxList<ObservationModel> observations = <ObservationModel>[].obs;
  final Rx<AddressModel?> address = Rx<AddressModel?>(null);
  final RxBool isLoadingObs = true.obs;
  final RxBool isLoadingDir = true.obs;

  // Agregar un TextEditingController para la nueva observación
  final TextEditingController _newObservationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _observationService = Get.find<ObservationService>();
    _addressService = Get.find<AddressService>();
    _providersController = Get.find<ProvidersController>();
  }

  void _loadData() {
    _loadObservations();
    if (widget.provider.addressId != null) {
      _loadAddress();
    } else {
      isLoadingDir.value = false;
    }
  }

  Future<void> _loadObservations() async {
    try {
      isLoadingObs.value = true;
      final result = await _observationService.getObservationsBySource(
          'providers', widget.provider.id);

      // Ordenar por fecha de creación (más recientes primero)
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      observations.assignAll(result);
    } catch (_) {
      // Manejo silencioso de errores
    } finally {
      isLoadingObs.value = false;
    }
  }

  Future<void> _loadAddress() async {
    try {
      isLoadingDir.value = true;
      if (widget.provider.addressId != null) {
        final result =
            await _addressService.getAddressById(widget.provider.addressId!);
        address.value = result;
      }
    } catch (_) {
      // Manejo silencioso de errores
    } finally {
      isLoadingDir.value = false;
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
                    _buildProviderDataSection(theme),
                    const SizedBox(height: 24),
                    _buildContactSection(theme),
                    Obx(() => _buildAddressSection(theme)),
                    const SizedBox(height: 24),
                    _buildObservationsSection(theme),
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

  Widget _buildHeaderSection(ThemeData theme) {
    return Row(
      children: [
        const Spacer(),
        Text(
          'Información del Proveedor',
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

  Widget _buildProviderDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Datos del Proveedor'),
        const SizedBox(height: 16),
        _buildInfoRow(theme, 'Empresa:', widget.provider.companyName),
        Obx(() => _buildInfoRow(
            theme,
            'Especialidad:',
            _providersController
                .getSpecialtyName(widget.provider.specialtyId))),
        _buildInfoRow(theme, 'Tipo de servicio:',
            widget.provider.serviceType ?? 'No especificado'),
        _buildInfoRow(theme, 'Condiciones de pago:',
            widget.provider.paymentTerms ?? 'No especificado'),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Información de Contacto'),
        const SizedBox(height: 16),
        _buildInfoRow(theme, 'Contacto principal:',
            widget.provider.mainContactName ?? 'No especificado'),
        _buildInfoRow(theme, 'Teléfono:',
            widget.provider.phoneNumber ?? 'No especificado'),
        _buildInfoRow(theme, 'Correo electrónico:',
            widget.provider.email ?? 'No especificado'),
        _buildInfoRow(theme, 'RFC:',
            widget.provider.taxIdentificationNumber ?? 'No especificado'),
      ],
    );
  }

  Widget _buildAddressSection(ThemeData theme) {
    if (isLoadingDir.value) {
      return Column(
        children: [
          const SizedBox(height: 24),
          _buildSectionTitle(theme, 'Dirección'),
          const SizedBox(height: 16),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    if (address.value != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSectionTitle(theme, 'Dirección'),
          const SizedBox(height: 16),
          _buildInfoRow(theme, 'Calle y número:',
              '${address.value!.street} ${address.value!.streetNumber}'),
          _buildInfoRow(theme, 'Colonia:', address.value!.neighborhood),
          _buildInfoRow(theme, 'Código postal:', address.value!.postalCode),
          if (address.value!.state != null && address.value!.state!.isNotEmpty)
            _buildInfoRow(theme, 'Estado:', address.value!.state!),
          if (address.value!.country != null &&
              address.value!.country!.isNotEmpty)
            _buildInfoRow(theme, 'País:', address.value!.country!),
        ],
      );
    }

    return Container();
  }

  Widget _buildObservationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Observaciones'),
        const SizedBox(height: 16),
        // Contenedor único para ambos elementos
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
              // Formulario para agregar observaciones (sin su propio borde)
              Padding(
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
                    // Fila con TextField y botón alineados
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextField expandido con solo 2 líneas
                        Expanded(
                          child: TextField(
                            controller: _newObservationController,
                            decoration: InputDecoration(
                              hintText: 'Escriba su observación aquí...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12, // Reducir el padding vertical
                              ),
                            ),
                            maxLines: 2, // Cambiar a 2 líneas
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Botón de agregar con altura ajustada
                        SizedBox(
                          height:
                              60, // Ajustar altura para coincidir con un TextField de 2 líneas
                          child: ElevatedButton(
                            onPressed: () => _addNewObservation(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(
                                  12), // Reducir el padding
                              minimumSize: const Size(48, 48),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_comment,
                                  size:
                                      20, // Reducir ligeramente el tamaño del icono
                                  color: Colors.white,
                                ),
                                SizedBox(height: 4), // Reducir espacio
                                Text(
                                  'Agregar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13, // Reducir tamaño de texto
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
              ),
              // Divisor entre formulario y lista
              Divider(
                color: theme.colorScheme.outline.withOpacity(0.5),
                height: 1,
                thickness: 1,
              ),
              // Lista de observaciones con scroll
              Obx(() {
                if (isLoadingObs.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Contenido de las observaciones
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: observations.isEmpty
                      ? Text(
                          'No hay observaciones registradas para este proveedor.',
                          style: theme.textTheme.bodyLarge,
                        )
                      : SizedBox(
                          height: observations.length > 6
                              ? 300
                              : null, // Altura fija si hay más de 6 observaciones
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: observations
                                  .map((obs) =>
                                      _buildObservationTimelineItem(theme, obs))
                                  .toList(),
                            ),
                          ),
                        ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void _addNewObservation() async {
    final text = _newObservationController.text.trim();
    if (text.isEmpty) return;

    try {
      await _observationService.addQuickObservation(
        sourceTable: 'providers',
        sourceId: widget.provider.id,
        text: text,
        userId: 1, // Usar el ID del usuario actual en un sistema real
      );

      // Limpiar el campo de texto
      _newObservationController.clear();

      // Recargar las observaciones
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

  Widget _buildObservationTimelineItem(ThemeData theme, ObservationModel obs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador de timeline
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
          // Contenido de la observación
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
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centrar verticalmente
                children: [
                  // Texto de la observación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _observationService.getFormattedCreationDate(obs),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          obs.observation,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Separación entre texto y botones
                  // Botones de editar y eliminar
                  Row(
                    children: [
                      // Botón de editar
                      Container(
                        height: 34,
                        width: 34,
                        margin: const EdgeInsets.only(
                            right: 12), // Separación entre botones
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
                      // Botón de eliminar
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
                  // Actualizar la observación
                  await _observationService.updateObservation(
                    observation.copyWith(observation: text),
                  );

                  // Cerrar el diálogo
                  Get.back();

                  // Recargar las observaciones
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
                // Eliminar la observación
                await _observationService.deleteObservation(observation.id);

                // Cerrar el diálogo
                Get.back();

                // Recargar las observaciones
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

  Widget _buildFooterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DetailActionButton(
          type: DetailActionType.edit,
          onPressed: widget.onEditPressed ?? () {},
        ),
        const SizedBox(width: 60),
        DetailActionButton(
          type: DetailActionType.delete,
          onPressed: () async {
            try {
              await _providersController
                  .setProviderInactive(widget.provider.id);
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              if (widget.onClose != null) {
                widget.onClose!();
              }
            } catch (e) {
              Get.snackbar(
                'Error',
                'No se pudo desactivar el proveedor',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError,
              );
            }
          },
          isOutlined: true,
          customText: 'Desactivar',
          confirmationTitle: 'Desactivar proveedor',
          confirmationMessage:
              '¿Está seguro que desea desactivar este proveedor? Podrá reactivarlo posteriormente.',
        ),
      ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${_formatTimeDigit(date.hour)}:${_formatTimeDigit(date.minute)}';
  }

  String _formatTimeDigit(int digit) {
    return digit.toString().padLeft(2, '0');
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
