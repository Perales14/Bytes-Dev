import 'package:get/get.dart';
import '../models/usuario_model.dart';

class EmployeeRepository {
  Future<List<UsuarioModel>> getEmployees() async {
    // Simulamos un delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Usando el modelo UsuarioModel existente
    return [
      UsuarioModel(
        id: 1,
        rolId: 2,
        nombreCompleto: 'Luis Muñoz',
        email: 'luis@example.com',
        telefono: '8333011843',
        nss: '12345',
        contrasenaHash: '',
        fechaIngreso: DateTime(2022, 5, 10),
        cargo: 'Desarrollador',
        departamento: 'Backend',
        estadoId: 1,
      ),
      UsuarioModel(
        id: 2,
        rolId: 2,
        nombreCompleto: 'Julian Cruz',
        email: 'julian@example.com',
        telefono: '8333011843',
        nss: '67890',
        contrasenaHash: '',
        fechaIngreso: DateTime(2022, 7, 15),
        cargo: 'Desarrollador',
        departamento: 'Frontend',
        estadoId: 1,
      ),
      UsuarioModel(
        id: 3,
        rolId: 1,
        nombreCompleto: 'Alex Arath',
        email: 'falex@example.com',
        telefono: '8333011843',
        nss: '54321',
        contrasenaHash: '',
        fechaIngreso: DateTime(2021, 3, 20),
        cargo: 'Líder',
        departamento: 'Full Stack',
        estadoId: 1,
      ),
      UsuarioModel(
        id: 4,
        rolId: 1,
        nombreCompleto: 'Marco Saenz',
        email: 'bodrio@example.com',
        telefono: '8333011843',
        nss: '98765',
        contrasenaHash: '',
        fechaIngreso: DateTime(2021, 5, 5),
        cargo: 'Líder',
        departamento: 'Gestor',
        estadoId: 1,
      ),
    ];
  }
}
