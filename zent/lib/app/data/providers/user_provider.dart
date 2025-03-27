import 'package:get/get.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProvider {
  final UserRepository _repository = UserRepository();

  // Basic CRUD operations
  Future<List<UserModel>> getAll() => _repository.getAll();
  Future<UserModel?> getById(int id) => _repository.getById(id);
  Future<UserModel> create(UserModel user) => _repository.create(user);
  Future<UserModel> update(UserModel user) => _repository.update(user);
  Future<void> delete(int id) => _repository.delete(id);

  // Custom operations with user roles
  Future<List<UserModel>> getEmployees() => _repository.getEmployees();
  Future<List<UserModel>> getAllEmployees() =>
      _repository.getAllEmployees(); // Nuevo método agregado
  Future<List<UserModel>> getActiveEmployees() =>
      _repository.getActiveEmployees();
  Future<List<UserModel>> getByRole(int roleId) =>
      _repository.getByRole(roleId);
  Future<List<UserModel>> getBySpecialty(int specialtyId) =>
      _repository.getBySpecialty(specialtyId);

  // Department operations
  Future<List<UserModel>> getEmployeesByDepartment(String department) =>
      _repository.getEmployeesByDepartment(department);

  // Validation operations
  Future<UserModel?> findByEmail(String email) =>
      _repository.findByEmail(email);
  Future<bool> existsSocialSecurityNumber(String ssn) =>
      _repository.existsSocialSecurityNumber(ssn);

  // Employee operations
  Future<UserModel> createEmployee(UserModel employee) =>
      _repository.createEmployee(employee);
  Future<List<UserModel>> getEmployeesBySupervisor(int supervisorId) =>
      _repository.getEmployeesBySupervisor(supervisorId);

  // Authentication
  Future<UserModel?> authenticate(String email, String passwordHash) =>
      _repository.authenticate(email, passwordHash);
}
