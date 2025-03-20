import '../models/base_model.dart';
import '../models/cliente_model.dart';
import 'base_repository.dart';

class ClienteRepository extends BaseRepository<ClienteModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  ClienteRepository() : super(tableName: 'clientes');

  @override
  ClienteModel fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] ?? 0,
      nombreEmpresa: map['nombre_empresa'],
      telefono: map['telefono'],
      email: map['email'],
      rfc: map['rfc'],
      tipo: map['tipo'],
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Sobrescribe el método toMapForDB para eliminar el campo enviado para Supabase
  @override
  Map<String, dynamic> toMapForDB(ClienteModel model) {
    // Obtenemos el mapa completo del modelo
    final map = model.toMap();

    // Eliminamos el campo enviado para Supabase
    // El campo se conservará en la base de datos local
    if (!useLocalDB) {
      map.remove('enviado');
    }

    return map;
  }

  // Métodos específicos para clientes

  // Método para buscar cliente por email
  Future<ClienteModel?> findByEmail(String email) async {
    try {
      final results = await query('email = ?', [email]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar cliente por email: $e');
    }
  }

  // Método para buscar cliente por RFC
  Future<ClienteModel?> findByRFC(String rfc) async {
    try {
      final results = await query('rfc = ?', [rfc]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar cliente por RFC: $e');
    }
  }

  // Método para buscar clientes por tipo
  Future<List<ClienteModel>> getByTipo(String tipo) async {
    try {
      return await query('tipo = ?', [tipo]);
    } catch (e) {
      throw Exception('Error al obtener clientes por tipo: $e');
    }
  }

  // Método para buscar por nombre completo (nombre y apellidos)
  Future<List<ClienteModel>> findByNombreCompleto(
      String nombre, String apellidoPaterno, String? apellidoMaterno) async {
    try {
      if (apellidoMaterno != null && apellidoMaterno.isNotEmpty) {
        return await query(
            'nombre LIKE ? AND apellido_paterno LIKE ? AND apellido_materno LIKE ?',
            ['%$nombre%', '%$apellidoPaterno%', '%$apellidoMaterno%']);
      } else {
        return await query('nombre LIKE ? AND apellido_paterno LIKE ?',
            ['%$nombre%', '%$apellidoPaterno%']);
      }
    } catch (e) {
      throw Exception('Error al buscar clientes por nombre completo: $e');
    }
  }

  // Método para buscar por nombre de empresa
  Future<List<ClienteModel>> findByNombreEmpresa(String nombreEmpresa) async {
    try {
      return await query('nombre_empresa LIKE ?', ['%$nombreEmpresa%']);
    } catch (e) {
      throw Exception('Error al buscar clientes por nombre de empresa: $e');
    }
  }
}
