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
import '../controllers/providers_controller.dart';

class ProviderDetailsDialog extends StatefulWidget {
  final ProviderModel provider;
  final VoidCallback? onEditPressed;

  const ProviderDetailsDialog({
    super.key,
    required this.provider,
    this.onEditPressed,
  });

  @override
  State<ProviderDetailsDialog> createState() => _ProviderDetailsDialogState();
}

class _ProviderDetailsDialogState extends State<ProviderDetailsDialog> {
  late final ObservationService _observationService;
  late final AddressService _addressService;
  late final ProvidersController _providersController;

  final RxList<ObservationModel> observations = <ObservationModel>[].obs;
  final Rx<AddressModel?> address = Rx<AddressModel?>(null);
  final RxBool isLoadingObs = true.obs;
  final RxBool isLoadingDir = true.obs;

  @override
  void initState() {
    super.initState();

    // Verificamos y registramos las dependencias si es necesario
    _ensureDependencies();

    // Obtenemos las instancias
    _observationService = Get.find<ObservationService>();
    _addressService = Get.find<AddressService>();
    _providersController = Get.find<ProvidersController>();

    // Cargamos los datos
    _loadObservations();
    if (widget.provider.addressId != null) {
      _loadAddress();
    } else {
      isLoadingDir.value = false;
    }
  }

  void _ensureDependencies() {
    if (!Get.isRegistered<ObservationService>()) {
      Get.put(ObservationService());
    }

    if (!Get.isRegistered<AddressService>()) {
      Get.put(AddressService());
    }

    // Asumimos que el ProvidersController ya está registrado
    // ya que debería estar registrado en la página principal de proveedores
  }

  Future<void> _loadObservations() async {
    try {
      isLoadingObs.value = true;
      final result = await _observationService.getObservationsBySource(
          'providers', widget.provider.id);
      observations.assignAll(result);
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar observaciones: $e');
      }
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
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar dirección: $e');
      }
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
                    // Título con botón de cerrar
                    Row(
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
                    ),
                    const SizedBox(height: 36),

                    // Sección: Datos del Proveedor
                    _buildSectionTitle(theme, 'Datos del Proveedor'),
                    const SizedBox(height: 16),

                    // Nombre de empresa
                    _buildInfoRow(
                        theme, 'Empresa:', widget.provider.companyName),

                    // Especialidad
                    Obx(() => _buildInfoRow(
                        theme,
                        'Especialidad:',
                        _providersController
                            .getSpecialtyName(widget.provider.specialtyId))),

                    // Tipo de servicio
                    _buildInfoRow(theme, 'Tipo de servicio:',
                        widget.provider.serviceType ?? 'No especificado'),

                    // Condiciones de pago
                    _buildInfoRow(theme, 'Condiciones de pago:',
                        widget.provider.paymentTerms ?? 'No especificado'),

                    const SizedBox(height: 24),

                    // Sección: Información de Contacto
                    _buildSectionTitle(theme, 'Información de Contacto'),
                    const SizedBox(height: 16),

                    // Contacto principal
                    _buildInfoRow(theme, 'Contacto principal:',
                        widget.provider.mainContactName ?? 'No especificado'),

                    // Teléfono
                    _buildInfoRow(theme, 'Teléfono:',
                        widget.provider.phoneNumber ?? 'No especificado'),

                    // Email
                    _buildInfoRow(theme, 'Correo electrónico:',
                        widget.provider.email ?? 'No especificado'),

                    // RFC
                    _buildInfoRow(
                        theme,
                        'RFC:',
                        widget.provider.taxIdentificationNumber ??
                            'No especificado'),

                    // Sección: Dirección (si existe)
                    Obx(() {
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

                            // Calle y número
                            _buildInfoRow(theme, 'Calle y número:',
                                '${address.value!.street} ${address.value!.streetNumber}'),

                            // Colonia
                            _buildInfoRow(
                                theme, 'Colonia:', address.value!.neighborhood),

                            // CP
                            _buildInfoRow(theme, 'Código postal:',
                                address.value!.postalCode),

                            // Estado
                            if (address.value!.state != null &&
                                address.value!.state!.isNotEmpty)
                              _buildInfoRow(
                                  theme, 'Estado:', address.value!.state!),

                            // País
                            if (address.value!.country != null &&
                                address.value!.country!.isNotEmpty)
                              _buildInfoRow(
                                  theme, 'País:', address.value!.country!),
                          ],
                        );
                      }

                      return Container();
                    }),

                    // Sección: Observaciones
                    const SizedBox(height: 24),
                    _buildSectionTitle(theme, 'Observaciones'),
                    const SizedBox(height: 16),

                    // Observaciones
                    Obx(() {
                      if (isLoadingObs.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (observations.isEmpty) {
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
                            'No hay observaciones registradas para este proveedor.',
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
                          children: observations.map((obs) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    obs.observation,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Text(
                                    _formatDate(obs.createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  if (observations.last != obs)
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
}
