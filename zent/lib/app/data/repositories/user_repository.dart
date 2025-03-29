import '../models/base_model.dart';
import '../models/user_model.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository<UserModel> {
  // Constructor passing correct table name to base repository
  UserRepository() : super(tableName: 'users');

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      roleId: map['role_id'] ?? 0,
      specialtyId: map['specialty_id'],
      name: map['name'] ?? '',
      fatherLastName: map['father_last_name'] ?? '',
      motherLastName: map['mother_last_name'],
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'],
      socialSecurityNumber: map['social_security_number'] ?? '',
      passwordHash: map['password_hash'] ?? '',
      entryDate: BaseModel.parseDateTime(map['entry_date']) ?? DateTime.now(),
      salary: map['salary'] != null
          ? (map['salary'] is double
              ? map['salary']
              : double.parse(map['salary'].toString()))
          : null,
      contractType: map['contract_type'],
      supervisorId: map['supervisor_id'],
      department: map['department'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get employees by role
  Future<List<UserModel>> getEmployees({int roleId = 2}) async {
    try {
      return await query('role_id = ?', [roleId]);
    } catch (e) {
      throw Exception('Error getting employees: $e');
    }
  }

  // Get employees by department
  Future<List<UserModel>> getEmployeesByDepartment(String department) async {
    try {
      return await query('department = ? AND role_id = ?', [department, 2]);
    } catch (e) {
      throw Exception('Error getting employees by department: $e');
    }
  }

  // Get active employees
  Future<List<UserModel>> getActiveEmployees() async {
    try {
      return await query('state_id = ? AND role_id = ?', [1, 2]);
    } catch (e) {
      throw Exception('Error getting active employees: $e');
    }
  }

  // Create employee with basic validations
  Future<UserModel> createEmployee(UserModel model) async {
    try {
      // Validate contract type
      if (model.contractType != null &&
          !['Temporal', 'Indefinido', 'Por Obra/Servicio']
              .contains(model.contractType)) {
        throw Exception('Invalid contract type');
      }

      return await create(model);
    } catch (e) {
      throw Exception('Error creating employee: $e');
    }
  }

  // Find user by email
  Future<UserModel?> findByEmail(String email) async {
    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding user by email: $e');
    }
  }

  // Authenticate user
  Future<UserModel?> authenticate(String email, String passwordHash) async {
    try {
      final results =
          await query('email = ? AND password_hash = ?', [email, passwordHash]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Authentication error: $e');
    }
  }

  // Get employees by supervisor
  Future<List<UserModel>> getEmployeesBySupervisor(int supervisorId) async {
    try {
      return await query(
          'supervisor_id = ? AND role_id = ?', [supervisorId, 2]);
    } catch (e) {
      throw Exception('Error getting employees by supervisor: $e');
    }
  }

  // Get users by role
  Future<List<UserModel>> getByRole(int roleId) async {
    try {
      return await query('role_id = ?', [roleId]);
    } catch (e) {
      throw Exception('Error getting users by role: $e');
    }
  }

  // Get users by specialty
  Future<List<UserModel>> getBySpecialty(int specialtyId) async {
    try {
      return await query('specialty_id = ?', [specialtyId]);
    } catch (e) {
      throw Exception('Error getting users by specialty: $e');
    }
  }

  // Check if social security number exists
  Future<bool> existsSocialSecurityNumber(String ssn) async {
    try {
      final results = await query('social_security_number = ?', [ssn]);
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('Error verifying social security number: $e');
    }
  }

  // Obtener todos los empleados sin filtro de rol
  Future<List<UserModel>> getAllEmployees() async {
    try {
      // Usa el método getAll() que probablemente heredaste del BaseRepository
      return await getAll();
    } catch (e) {
      throw Exception('Error al obtener todos los empleados: $e');
    }
  }

  /// Actualiza un empleado en la base de datos
  ///
  /// [model] El modelo de usuario con los datos actualizados
  /// Retorna el modelo de usuario actualizado con datos de la base de datos
  Future<UserModel> updateEmployee(UserModel model) async {
    try {
      // Validar el ID del empleado
      if (model.id <= 0) {
        throw Exception('ID de empleado inválido');
      }

      // Actualizar empleado usando el método base
      final updatedEmployee = await update(model);
      return updatedEmployee;
    } catch (e) {
      throw Exception('Error al actualizar empleado: $e');
    }
  }
}
