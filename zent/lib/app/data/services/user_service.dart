import 'package:get/get.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserService extends GetxService {
  final UserProvider _provider = UserProvider();

  // Basic user operations
  Future<List<UserModel>> getAllUsers() => _provider.getAll();
  Future<UserModel?> getUserById(int id) => _provider.getById(id);
  Future<UserModel> createUser(UserModel user) => _provider.create(user);
  Future<void> deleteUser(int id) => _provider.delete(id);

  // Employee operations
  Future<List<UserModel>> getEmployees() => _provider.getEmployees();
  Future<List<UserModel>> getAllEmployees() => _provider.getAllEmployees();
  Future<List<UserModel>> getActiveEmployees() =>
      _provider.getActiveEmployees();
  Future<UserModel> createEmployee(UserModel employee) =>
      _provider.createEmployee(employee);
  Future<List<UserModel>> getEmployeesBySupervisor(int supervisorId) =>
      _provider.getEmployeesBySupervisor(supervisorId);
  Future<List<UserModel>> getEmployeesByDepartment(String department) =>
      _provider.getEmployeesByDepartment(department);

  // Role and specialty operations
  Future<List<UserModel>> getUsersByRole(int roleId) =>
      _provider.getByRole(roleId);
  Future<List<UserModel>> getUsersBySpecialty(int specialtyId) =>
      _provider.getBySpecialty(specialtyId);

  // Authentication and validation
  Future<UserModel?> findUserByEmail(String email) =>
      _provider.findByEmail(email);
  Future<UserModel?> authenticate(String email, String passwordHash) =>
      _provider.authenticate(email, passwordHash);
  Future<bool> isSocialSecurityNumberAvailable(String ssn) =>
      _provider.existsSocialSecurityNumber(ssn).then((exists) => !exists);
}
