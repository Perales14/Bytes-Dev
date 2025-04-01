import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/observation_model.dart';
import '../../../data/services/observation_service.dart';
import '../../../shared/widgets/detail_action_button.dart';
import '../controllers/clients_controller.dart';

class ClientDetailsDialog extends StatefulWidget {
  final ClientModel client;
  final VoidCallback? onEditPressed;
  final VoidCallback? onClose;

  const ClientDetailsDialog({
    super.key,
    required this.client,
    this.onEditPressed,
    this.onClose,
  });

  @override
  State<ClientDetailsDialog> createState() => _ClientDetailsDialogState();
}

class _ClientDetailsDialogState extends State<ClientDetailsDialog> {
  final ObservationService _observationService = Get.find<ObservationService>();
  final RxList<ObservationModel> observations = <ObservationModel>[].obs;
  final RxBool isLoading = true.obs;
  final TextEditingController _newObservationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadObservations();
  }

  @override
  void dispose() {
    _newObservationController.dispose();
    if (widget.onClose != null) {
      widget.onClose!();
    }
    super.dispose();
  }

  Future<void> _loadObservations() async {
    try {
      isLoading.value = true;
      final result = await _observationService.getObservationsBySource(
          'clients', widget.client.id);

      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      observations.assignAll(result);
    } catch (e) {
      // Manejo silencioso
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
                    _buildHeaderSection(theme),
                    const SizedBox(height: 36),
                    _buildClientDataSection(theme),
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
    );
  }

  Widget _buildClientDataSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Datos Personales'),
        const SizedBox(height: 16),
        _buildInfoRow(theme, 'Nombre completo:', widget.client.fullName),
        if (widget.client.companyName != null &&
            widget.client.companyName!.isNotEmpty)
          _buildInfoRow(theme, 'Empresa:', widget.client.companyName!),
        if (widget.client.taxIdentificationNumber != null &&
            widget.client.taxIdentificationNumber!.isNotEmpty)
          _buildInfoRow(theme, 'RFC:', widget.client.taxIdentificationNumber!),
        _buildInfoRow(theme, 'Correo electrónico:',
            widget.client.email ?? 'No disponible'),
        _buildInfoRow(
            theme, 'Teléfono:', widget.client.phoneNumber ?? 'No disponible'),
        _buildInfoRow(theme, 'Tipo de cliente:',
            _formatClientType(widget.client.clientType)),
      ],
    );
  }

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
                  onPressed: _addNewObservation,
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
                      Icon(Icons.add_comment, size: 20, color: Colors.white),
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
      if (isLoading.value) {
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
                'No hay observaciones registradas para este cliente.',
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
    final bool isLast = observations.indexOf(obs) == observations.length - 1;

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
              if (!isLast)
                Container(
                  width: 2,
                  height: 16,
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
                          _observationService.getFormattedCreationDate(obs),
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
                  _buildObservationActions(theme, obs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationActions(ThemeData theme, ObservationModel obs) {
    return Row(
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
            child: const Icon(Icons.edit, size: 20, color: Colors.white),
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
            child: const Icon(Icons.delete, size: 20, color: Colors.white),
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
        sourceTable: 'clients',
        sourceId: widget.client.id,
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
            onPressed: () =>
                _updateObservation(observation, controller.text.trim()),
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

  void _updateObservation(ObservationModel observation, String text) async {
    if (text.isEmpty) return;

    try {
      await _observationService.updateObservation(
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
            onPressed: () => _deleteObservation(observation),
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

  void _deleteObservation(ObservationModel observation) async {
    try {
      await _observationService.deleteObservation(observation.id);
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
  }

  Widget _buildFooterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DetailActionButton(
          type: DetailActionType.edit,
          onPressed: widget.onEditPressed ??
              () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
                Get.find<ClientsController>()
                    .showEditClientDialog(widget.client.id);
              },
        ),
        const SizedBox(width: 60),
        DetailActionButton(
          type: DetailActionType.delete,
          onPressed: _deactivateClient,
          isOutlined: true,
          customText: 'Desactivar',
          confirmationTitle: 'Desactivar cliente',
          confirmationMessage:
              '¿Está seguro que desea desactivar este cliente? Podrá reactivarlo posteriormente.',
        ),
      ],
    );
  }

  Future<void> _deactivateClient() async {
    try {
      await Get.find<ClientsController>().setClientInactive(widget.client.id);

      // Solo cerramos el diálogo y notificamos después de que la operación sea exitosa
      if (Navigator.canPop(context)) {
        Navigator.pop(context);

        // Programamos la actualización para el siguiente frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.onClose != null) {
            widget.onClose!();
          }
          Get.find<ClientsController>().refreshData();
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo desactivar el cliente: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
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

  String _formatClientType(String? tipo) {
    if (tipo == null || tipo.isEmpty) {
      return 'Regular';
    }
    return tipo[0].toUpperCase() + tipo.substring(1);
  }
}
