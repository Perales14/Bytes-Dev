import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/client_model.dart';
import '../controllers/clients_controller.dart';
import 'add_clients_card.dart';
import 'client_card.dart';

class ClientsCardsGrid extends StatelessWidget {
  final List<ClientModel> clients;
  final VoidCallback onAddClient;
  final ClientsController controller;

  // Constantes de dimensiones
  static const double cardWidth = 300.0;
  static const double cardHeight = 170.0;
  static const double spacing = 28.0;
  static const double padding = 28.0;

  const ClientsCardsGrid({
    super.key,
    required this.clients,
    required this.onAddClient,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula cuántas tarjetas caben por fila considerando el padding
    final width = MediaQuery.of(context).size.width;
    final availableWidth = width - (padding * 2);

    // Calculamos cuántas tarjetas completas caben en el ancho disponible
    final cardsPerRow =
        ((availableWidth + spacing) / (cardWidth + spacing)).floor();

    // Garantizamos que siempre haya al menos 1 tarjeta por fila
    final itemsPerRow = cardsPerRow > 0 ? cardsPerRow : 1;

    // Total de elementos (clientes + tarjeta de agregar)
    final itemCount = clients.length + 1;

    return GridView.builder(
      padding: const EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: cardWidth / cardHeight, // Proporción ancho/alto fija
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          // La primera posición siempre es la tarjeta para agregar
          return AddClientsCard(onTap: onAddClient);
        }

        // Para el resto, obtenemos el cliente de la lista
        final client = clients[index - 1];

        // Determinamos el tipo de cliente
        String clientType = client.clientType ?? 'Regular';

        return ClientsCard(
          name:
              "${client.name} ${client.fatherLastName} ${client.motherLastName ?? ''}"
                  .trim(),
          position: client.companyName ?? 'Sin empresa',
          role: clientType,
          projectCount:
              0, // Estos valores se pueden calcular según tus necesidades
          taskCount: 0,
          onTap: () => controller.showClientDetails(client.id),
        );
      },
    );
  }
}
