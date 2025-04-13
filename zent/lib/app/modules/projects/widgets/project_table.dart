import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';

class ProjectsTable extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsTable({
    super.key,
    required this.projects,
  });

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
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: DataTableTheme(
                      data: DataTableThemeData(
                        headingRowColor:
                            WidgetStateProperty.all(Colors.blueGrey[800]),
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            return states.contains(WidgetState.selected)
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
                          DataColumn(label: Center(child: Text('Cliente'))),
                          DataColumn(label: Center(child: Text('Gerente'))),
                          DataColumn(label: Center(child: Text('Inicio'))),
                          DataColumn(
                              label: Center(child: Text('Fin Estimado'))),
                          DataColumn(label: Center(child: Text('Presupuesto'))),
                          DataColumn(label: Center(child: Text('Estado'))),
                          DataColumn(label: Center(child: Text('Acciones'))),
                        ],
                        rows: projects.map((project) {
                          return DataRow(
                            cells: [
                              _buildCell(project.name),
                              _buildCell(project.clientId.toString()),
                              _buildCell(project.managerId.toString()),
                              _buildCell(_formatDate(project.startDate)),
                              _buildCell(_formatDate(project.estimatedEndDate)),
                              _buildCell(
                                  _formatCurrency(project.estimatedBudget)),
                              _buildCell(_getProjectStatus(project)),
                              DataCell(
                                Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'No definido';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return 'No definido';
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _getProjectStatus(ProjectModel project) {
    if (project.actualEndDate != null) return 'Completado';
    if (project.startDate == null) return 'No iniciado';
    if (_isOverdue(project)) return 'Atrasado';
    return 'En progreso';
  }

  bool _isOverdue(ProjectModel project) {
    if (project.estimatedEndDate == null || project.actualEndDate != null) {
      return false;
    }
    return DateTime.now().isAfter(project.estimatedEndDate!);
  }
}
