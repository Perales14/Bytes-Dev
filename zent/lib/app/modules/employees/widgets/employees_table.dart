import 'package:flutter/material.dart';

class EmployeesTable extends StatelessWidget {
  final List<Map<String, dynamic>> employees;

  const EmployeesTable({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DataTable(
            columns: const [
              DataColumn(
                label: Center(child: Text('Nombre')), // Centrar el texto del encabezado
              ),
              DataColumn(
                label: Center(child: Text('NSS')), // Centrar el texto del encabezado
              ),
              DataColumn(
                label: Center(child: Text('Email')), // Centrar el texto del encabezado
              ),
              DataColumn(
                label: Center(child: Text('Cargo')), // Centrar el texto del encabezado
              ),
              DataColumn(
                label: Center(child: Text('Departamento')), // Centrar el texto del encabezado
              ),
              DataColumn(
                label: Center(child: Text('Telefono')), // Centrar el texto del encabezado
              ),
            ],
            rows: employees.map((empleado) {
              return DataRow(cells: [
                DataCell(Center(child: Text(empleado['nombre_completo'] ?? 'Sin nombre'))),
                DataCell(Center(child: Text(empleado['nss'] ?? 'Sin NSS'))),
                DataCell(Center(child: Text(empleado['email'] ?? 'Sin email'))),
                DataCell(Center(child: Text(empleado['cargo'] ?? 'Sin cargo'))),
                DataCell(Center(child: Text(empleado['departamento'] ?? 'Sin departamento'))),
                DataCell(Center(child: Text(empleado['telefono'] ?? 'Sin telefono'))),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }
}
