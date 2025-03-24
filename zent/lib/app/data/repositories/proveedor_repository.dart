import '../models/base_model.dart';
import '../models/proveedor_model.dart';
import 'base_repository.dart';

class ProveedorRepository extends BaseRepository<ProveedorModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  ProveedorRepository() : super(tableName: 'proveedores');

  @override
  ProveedorModel fromMap(Map<String, dynamic> map) {
    return ProveedorModel(
      id: map['id'] ?? 0,
      especialidadId: map['especialidad_id'] ?? 0,
      nombreEmpresa: map['nombre_empresa'] ?? '',
      contactoPrincipal: map['contacto_principal'],
      telefono: map['telefono'],
      email: map['email'],
      rfc: map['rfc'],
      tipoServicio: map['tipo_servicio'],
      condicionesPago: map['condiciones_pago'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 1,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para proveedores

  // Método para buscar proveedor por email
  Future<ProveedorModel?> findByEmail(String email) async {
    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar proveedor por email: $e');
    }
  }

  // Método para buscar proveedor por RFC
  Future<ProveedorModel?> findByRFC(String rfc) async {
    try {
      final results = await query('rfc = ?', [rfc]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar proveedor por RFC: $e');
    }
  }

  // Método para buscar proveedores por especialidad
  Future<List<ProveedorModel>> getByEspecialidad(int especialidadId) async {
    try {
      return await query('especialidad_id = ?', [especialidadId]);
    } catch (e) {
      throw Exception('Error al obtener proveedores por especialidad: $e');
    }
  }

  // Método para buscar proveedores por nombre de empresa
  Future<List<ProveedorModel>> findByNombreEmpresa(String nombreEmpresa) async {
    try {
      return await query('nombre_empresa LIKE ?', ['%$nombreEmpresa%']);
    } catch (e) {
      throw Exception('Error al buscar proveedores por nombre de empresa: $e');
    }
  }

  // Método para buscar proveedores por tipo de servicio
  Future<List<ProveedorModel>> getByTipoServicio(String tipoServicio) async {
    try {
      return await query('tipo_servicio = ?', [tipoServicio]);
    } catch (e) {
      throw Exception('Error al obtener proveedores por tipo de servicio: $e');
    }
  }

  // Método para buscar por contacto principal
  Future<List<ProveedorModel>> findByContacto(String contacto) async {
    try {
      return await query('contacto_principal LIKE ?', ['%$contacto%']);
    } catch (e) {
      throw Exception('Error al buscar proveedores por contacto principal: $e');
    }
  }

  // Método para verificar si ya existe un RFC registrado
  Future<bool> existsRFC(String rfc) async {
    if (rfc.isEmpty) return false;

    try {
      final results = await query('rfc = ?', [rfc]);
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar RFC: $e');
    }
  }

  // Método para verificar si ya existe un email registrado
  Future<bool> existsEmail(String email) async {
    if (email.isEmpty) return false;

    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar email: $e');
    }
  }
}
