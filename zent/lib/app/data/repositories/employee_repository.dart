import 'package:get/get.dart';
import '../models/base_model.dart';
import '../models/usuario_model.dart';
import 'base_repository.dart';

class EmployeeRepository extends BaseRepository<UsuarioModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  EmployeeRepository() : super(tableName: 'usuarios');

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? 0,
      rolId: map['rol_id'] ?? 0,
      especialidadId: map['especialidad_id'],
      nombreCompleto: map['nombre_completo'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nss: map['nss'] ?? '',
      contrasenaHash: map['contrasena_hash'] ?? '',
      fechaIngreso:
          BaseModel.parseDateTime(map['fecha_ingreso']) ?? DateTime.now(),
      salario: map['salario'],
      tipoContrato: map['tipo_contrato'],
      supervisorId: map['supervisor_id'],
      // cargo: map['cargo'],
      departamento: map['departamento'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para empleados
  Future<List<UsuarioModel>> getEmployees() async {
    try {
      // Para distinguir empleados de otros usuarios, podríamos usar rol_id
      // Asumiendo que los empleados tienen ciertos roles (ejemplo: 2)
      return await query('rol_id = ?', [2]);
    } catch (e) {
      throw Exception('Error al obtener empleados: $e');
    }
  }

  // Método para obtener empleados por departamento
  Future<List<UsuarioModel>> getEmployeesByDepartment(
      String departamento) async {
    try {
      return await query('departamento = ? AND rol_id = ?', [departamento, 2]);
    } catch (e) {
      throw Exception('Error al obtener empleados por departamento: $e');
    }
  }

  // Método para obtener empleados por cargo
  Future<List<UsuarioModel>> getEmployeesByCargo(String cargo) async {
    try {
      return await query('cargo = ? AND rol_id = ?', [cargo, 2]);
    } catch (e) {
      throw Exception('Error al obtener empleados por cargo: $e');
    }
  }


  // Método para obtener empleados activos (asumiendo estado_id 1 es activo)
  Future<List<UsuarioModel>> getActiveEmployees() async {
    try {
      return await query('estado_id = ? AND rol_id = ?', [1, 2]);
    } catch (e) {
      throw Exception('Error al obtener empleados activos: $e');
    }
  }

  // Método para crear un empleado con validaciones básicas
  @override
  Future<UsuarioModel> create(UsuarioModel model) async {
    try {
      // Asegurarse de que tenga un rol de empleado (asumiendo que 2 es rol de empleado)
      if (model.rolId != 2) {
        model.rolId = 2; // Asignar rol de empleado
      }

      // Llamar al método create de la clase base y devolver el modelo completo
      return await super.create(model);
    } catch (e) {
      throw Exception('Error al crear empleado: $e');
    }
  }

  // Alternativa más simple: usar el método heredado
  @override
  Future<UsuarioModel?> getById(int id) async {
    try {
      print('Consultando empleado con ID: $id');
      
      // Usar el método ya implementado en BaseRepository
      final employee = await super.getById(id);
      
      if (employee == null) {
        print('No se encontraron datos para el ID: $id');
      } else {
        print('Datos del empleado recuperados: ${employee.nombreCompleto}');
      }
      
      return employee;
    } catch (e) {
      print('Error en getById: $e');
      throw Exception('Error al consultar empleado: $e');
    }
  }
}
