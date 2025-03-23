import 'package:flutter/material.dart';

class EmployeesTable extends StatelessWidget {
  final List<Map<String, dynamic>> employees;

  const EmployeesTable({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8, // Ajusta la altura según sea necesario
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Desplazamiento vertical
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                    child: DataTableTheme(
                      data: DataTableThemeData(
                        headingRowColor: MaterialStateProperty.all(Colors.blueGrey[800]),
                        headingTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,
                        ),
                        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return states.contains(MaterialState.selected)
                                ? Colors.blueGrey[100]
                                : null;
                          },
                        ),
                      ),
                      child: DataTable(
                        columnSpacing: 24.0,
                        dividerThickness: 1.2,
                        columns: const [
                          DataColumn(label: Center(child: Text('Nombre'))),
                          DataColumn(label: Center(child: Text('NSS'))),
                          DataColumn(label: Center(child: Text('Email'))),
                          DataColumn(label: Center(child: Text('Cargo'))),
                          DataColumn(label: Center(child: Text('Departamento'))),
                          DataColumn(label: Center(child: Text('Teléfono'))),
                          DataColumn(label: Center(child: Text('Editar'))),
                        ],
                        rows: employees.map((empleado) {
                          return DataRow(
                            cells: [
                              _buildCell(empleado['nombre_completo'] ?? 'Sin nombre'),
                              _buildCell(empleado['nss'] ?? 'Sin NSS'),
                              _buildCell(empleado['email'] ?? 'Sin email'),
                              _buildCell(empleado['cargo'] ?? 'Sin cargo'),
                              _buildCell(empleado['departamento'] ?? 'Sin departamento'),
                              _buildCell(empleado['telefono'] ?? 'Sin teléfono'),
                              DataCell(
                                Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataCell _buildCell(String text) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
