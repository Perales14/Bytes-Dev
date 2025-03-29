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
  // Servicios
  late final ObservationService _observationService;
  late final AddressService _addressService;
  late final ProvidersController _providersController;

  // Variables reactivas
  final RxList<ObservationModel> observations = <ObservationModel>[].obs;
  final Rx<AddressModel?> address = Rx<AddressModel?>(null);
  final RxBool isLoadingObs = true.obs;
  final RxBool isLoadingDir = true.obs;

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
        Obx(() {
          if (isLoadingObs.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            child: observations.isEmpty
                ? Text(
                    'No hay observaciones registradas para este proveedor.',
                    style: theme.textTheme.bodyLarge,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: observations
                        .map((obs) => _buildObservationItem(theme, obs))
                        .toList(),
                  ),
          );
        }),
      ],
    );
  }

  Widget _buildObservationItem(ThemeData theme, ObservationModel obs) {
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
              color: theme.colorScheme.outline.withOpacity(0.2),
              height: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: widget.onEditPressed,
        icon: const Icon(Icons.edit),
        label: const Text('Editar información'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${_formatTimeDigit(date.hour)}:${_formatTimeDigit(date.minute)}';
  }

  String _formatTimeDigit(int digit) {
    return digit.toString().padLeft(2, '0');
  }
}
