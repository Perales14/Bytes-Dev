import 'package:get/get.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserService extends GetxService {
  final UserProvider _provider = UserProvider();

  // Operaciones básicas de usuario
  Future<List<UserModel>> getAllUsers() => _provider.getAll();
  Future<UserModel?> getUserById(int id) => _provider.getById(id);
  Future<UserModel> createUser(UserModel user) => _provider.create(user);
  Future<UserModel> updateUser(UserModel user) => _provider.update(user);
  Future<void> deleteUser(int id) => _provider.delete(id);

  // Operaciones de empleados
  Future<List<UserModel>> getEmployees() => _provider.getEmployees();
  Future<List<UserModel>> getAllEmployees() => _provider.getAllEmployees();
  Future<List<UserModel>> getActiveEmployees() =>
      _provider.getActiveEmployees();
  Future<UserModel> createEmployee(UserModel employee) =>
      _provider.createEmployee(employee);
  Future<UserModel> updateEmployee(UserModel employee) =>
      _provider.updateEmployee(employee);
  Future<List<UserModel>> getEmployeesBySupervisor(int supervisorId) =>
      _provider.getEmployeesBySupervisor(supervisorId);
  Future<List<UserModel>> getEmployeesByDepartment(String department) =>
      _provider.getEmployeesByDepartment(department);

  Future<UserModel> setEmployeeInactive(int id) async {
    try {
      final employee = await getUserById(id);
      if (employee == null) {
        throw Exception('No se encontró el empleado con ID $id');
      }
      final updatedEmployee = employee.copyWith(stateId: 2);
      return await updateEmployee(updatedEmployee);
    } catch (e) {
      throw Exception('Error al desactivar el empleado: $e');
    }
  }

  // Operaciones de roles y especialidades
  Future<List<UserModel>> getUsersByRole(int roleId) =>
      _provider.getByRole(roleId);
  Future<List<UserModel>> getUsersBySpecialty(int specialtyId) =>
      _provider.getBySpecialty(specialtyId);

  // Autenticación y validación
  Future<UserModel?> findUserByEmail(String email) =>
      _provider.findByEmail(email);
  Future<UserModel?> authenticate(String email, String passwordHash) =>
      _provider.authenticate(email, passwordHash);

  Future<Map<String, dynamic>> validateCredentials(
          String email, String passwordHash,
          {bool debugMode = false}) =>
      _provider.validateCredentials(email, passwordHash, debugMode: debugMode);

  Future<bool> isSocialSecurityNumberAvailable(String ssn) =>
      _provider.existsSocialSecurityNumber(ssn).then((exists) => !exists);
}
