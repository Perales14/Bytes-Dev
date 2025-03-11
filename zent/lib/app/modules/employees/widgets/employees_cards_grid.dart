import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/usuario_model.dart';
import 'add_employee_card.dart';
import 'emplooyees_card.dart';

class EmployeesCardsGrid extends StatelessWidget {
  final List<UsuarioModel> employees;
  final VoidCallback onAddEmployee;

  // Constantes de dimensiones
  static const double cardWidth = 300.0;
  static const double cardHeight = 170.0;
  static const double spacing = 28.0;
  static const double padding = 28.0;

  const EmployeesCardsGrid({
    super.key,
    required this.employees,
    required this.onAddEmployee,
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

    // Total de elementos (empleados + tarjeta de agregar)
    final itemCount = employees.length + 1;

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
          return AddEmployeeCard(onTap: onAddEmployee);
        }

        // Para el resto, obtenemos el empleado de la lista
        final employee = employees[index - 1];

        // Determinamos el rol basado en el rolId
        String role = employee.rolId == 1 ? 'Líder' : 'Empleado';

        return EmployeesCard(
          name: employee.nombreCompleto,
          position: employee.cargo ?? 'Sin cargo',
          role: role,
          projectCount:
              2, // Valores de ejemplo, podrías agregar estos campos al modelo
          taskCount: 4, // o calcularlos de otra fuente de datos
          onTap: () => Get.toNamed(
              '/employees/${employee.id}'), //Con esto se podra abrir el perfil de empleado un empleado segun un id especifico
        );
      },
    );
  }
}
