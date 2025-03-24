import 'package:flutter/material.dart';
import '../../../data/models/proveedor_model.dart';

class ProviderCard extends StatelessWidget {
  final ProveedorModel provider;
  final Function onTap;

  const ProviderCard({
    required this.provider,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera con nombre e icono
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      provider.nombreEmpresa,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.business, size: 24),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),

              // Detalles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo de servicio
                    if (provider.tipoServicio != null)
                      _buildInfoRow(theme,
                          icon: Icons.category_outlined,
                          text: provider.tipoServicio!),

                    // Contacto principal
                    if (provider.contactoPrincipal != null)
                      _buildInfoRow(theme,
                          icon: Icons.person_outlined,
                          text: provider.contactoPrincipal!),

                    // Teléfono
                    if (provider.telefono != null)
                      _buildInfoRow(theme,
                          icon: Icons.phone_outlined, text: provider.telefono!),

                    // Email
                    if (provider.email != null)
                      _buildInfoRow(
                        theme,
                        icon: Icons.email_outlined,
                        text: provider.email!,
                        overflow: true,
                      ),
                  ],
                ),
              ),

              // Footer con condiciones de pago
              if (provider.condicionesPago != null) ...[
                const Divider(),
                _buildInfoRow(
                  theme,
                  icon: Icons.payments_outlined,
                  text: 'Pago: ${provider.condicionesPago}',
                  isBold: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme, {
    required IconData icon,
    required String text,
    bool overflow = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: overflow ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
