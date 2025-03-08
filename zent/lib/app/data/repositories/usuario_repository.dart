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
      cargo: map['cargo'],
      departamento: map['departamento'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para usuarios

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
      return await query('supervisor_id = ?', [supervisorId]);
    } catch (e) {
      throw Exception('Error al obtener empleados: $e');
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
