import 'package:get/get.dart';
import '../models/base_model.dart';
import '../models/usuario_model.dart';
import 'base_repository.dart';

class UsuarioRepository extends BaseRepository<UsuarioModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  UsuarioRepository() : super(tableName: 'usuarios');

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? 0,
      rolId: map['rol_id'] ?? 0,
      especialidadId: map['especialidad_id'],
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'],
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nss: map['nss'] ?? '',
      contrasenaHash: map['contrasena_hash'] ?? '',
      fechaIngreso:
          BaseModel.parseDateTime(map['fecha_ingreso']) ?? DateTime.now(),
      salario: map['salario'] != null
          ? (map['salario'] is double
              ? map['salario']
              : double.parse(map['salario'].toString()))
          : null,
      tipoContrato: map['tipo_contrato'],
      supervisorId: map['supervisor_id'],
      departamento: map['departamento'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos para obtener empleados (usuarios con rol específico)
  Future<List<UsuarioModel>> getEmployees({int rolId = 2}) async {
    try {
      return await query('rol_id = ?', [rolId]);
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

  // Método para obtener empleados activos
  Future<List<UsuarioModel>> getActiveEmployees() async {
    try {
      return await query('estado_id = ? AND rol_id = ?', [1, 2]);
    } catch (e) {
      throw Exception('Error al obtener empleados activos: $e');
    }
  }

  // Método para crear un empleado con validaciones básicas
  Future<UsuarioModel> createEmployee(UsuarioModel model) async {
    try {
      // Asegurarse de que tenga un rol de empleado
      if (model.rolId != 2) {
        model = model.copyWith(rolId: 2);
      }

      // Verificar tipoContrato válido
      if (model.tipoContrato != null &&
          !['Temporal', 'Indefinido', 'Por Obra']
              .contains(model.tipoContrato)) {
        throw Exception('Tipo de contrato inválido');
      }

      return await create(model);
    } catch (e) {
      throw Exception('Error al crear empleado: $e');
    }
  }

  // Método para buscar un usuario por email
  Future<UsuarioModel?> findByEmail(String email) async {
    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar usuario por email: $e');
    }
  }

  // Método para autenticar usuario
  Future<UsuarioModel?> authenticate(String email, String passwordHash) async {
    try {
      final results = await query(
          'email = ? AND contrasena_hash = ?', [email, passwordHash]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error en la autenticación: $e');
    }
  }

  // Método para obtener empleados por supervisor
  Future<List<UsuarioModel>> getEmployeesBySupervisor(int supervisorId) async {
    try {
      return await query('supervisor_id = ? AND rol_id = ?', [supervisorId, 2]);
    } catch (e) {
      throw Exception('Error al obtener empleados por supervisor: $e');
    }
  }

  // Método para obtener usuarios por rol
  Future<List<UsuarioModel>> getByRole(int rolId) async {
    try {
      return await query('rol_id = ?', [rolId]);
    } catch (e) {
      throw Exception('Error al obtener usuarios por rol: $e');
    }
  }

  // Método para obtener usuarios por especialidad
  Future<List<UsuarioModel>> getByEspecialidad(int especialidadId) async {
    try {
      return await query('especialidad_id = ?', [especialidadId]);
    } catch (e) {
      throw Exception('Error al obtener usuarios por especialidad: $e');
    }
  }

  // Método para verificar si ya existe un nss registrado
  Future<bool> existsNSS(String nss) async {
    try {
      final results = await query('nss = ?', [nss]);
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar NSS: $e');
    }
  }
}
