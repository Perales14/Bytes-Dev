import 'package:flutter/material.dart';
import '../../../data/models/cliente_model.dart';

class ClientsTable extends StatelessWidget {
  final List<ClienteModel> clients;

  const ClientsTable({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DataTable(
            columns: const [
              DataColumn(
                label: Center(child: Text('Nombre')),
              ),
              DataColumn(
                label: Center(child: Text('Empresa')),
              ),
              DataColumn(
                label: Center(child: Text('Email')),
              ),
              DataColumn(
                label: Center(child: Text('Teléfono')),
              ),
              DataColumn(
                label: Center(child: Text('RFC')),
              ),
              DataColumn(
                label: Center(child: Text('Tipo')),
              ),
            ],
            rows: clients.map((cliente) {
              final nombreCompleto =
                  "${cliente.nombre} ${cliente.apellidoPaterno} ${cliente.apellidoMaterno ?? ''}"
                      .trim();

              return DataRow(cells: [
                DataCell(Center(child: Text(nombreCompleto))),
                DataCell(Center(
                    child: Text(cliente.nombreEmpresa ?? 'Sin empresa'))),
                DataCell(Center(child: Text(cliente.email ?? 'Sin email'))),
                DataCell(
                    Center(child: Text(cliente.telefono ?? 'Sin teléfono'))),
                DataCell(Center(child: Text(cliente.rfc ?? 'Sin RFC'))),
                DataCell(Center(child: Text(cliente.tipo ?? 'Regular'))),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }
}
