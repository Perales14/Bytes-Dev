import '../models/base_model.dart';
import '../models/direccion_model.dart';
import 'base_repository.dart';

class DireccionRepository extends BaseRepository<DireccionModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  DireccionRepository() : super(tableName: 'direcciones');

  @override
  DireccionModel fromMap(Map<String, dynamic> map) {
    return DireccionModel(
      id: map['id'] ?? 0,
      calle: map['calle'] ?? '',
      numero: map['numero'] ?? '',
      colonia: map['colonia'] ?? '',
      cp: map['cp'] ?? '',
      estado: map['estado'],
      pais: map['pais'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para direcciones

  // Método para buscar direcciones por colonia
  Future<List<DireccionModel>> findByColonia(String colonia) async {
    try {
      return await query('colonia = ?', [colonia]);
    } catch (e) {
      throw Exception('Error al buscar direcciones por colonia: $e');
    }
  }

  // Método para buscar direcciones por código postal
  Future<List<DireccionModel>> findByCP(String cp) async {
    try {
      return await query('cp = ?', [cp]);
    } catch (e) {
      throw Exception('Error al buscar direcciones por código postal: $e');
    }
  }

  // Método para buscar direcciones por estado
  Future<List<DireccionModel>> findByEstado(String estado) async {
    try {
      return await query('estado = ?', [estado]);
    } catch (e) {
      throw Exception('Error al buscar direcciones por estado: $e');
    }
  }

  // Método para obtener direcciones por combinación de campos
  Future<List<DireccionModel>> findByCriteria(
      {String? calle, String? colonia, String? cp}) async {
    try {
      List<String> conditions = [];
      List<dynamic> arguments = [];

      if (calle != null && calle.isNotEmpty) {
        conditions.add('calle LIKE ?');
        arguments.add('%$calle%');
      }

      if (colonia != null && colonia.isNotEmpty) {
        conditions.add('colonia LIKE ?');
        arguments.add('%$colonia%');
      }

      if (cp != null && cp.isNotEmpty) {
        conditions.add('cp = ?');
        arguments.add(cp);
      }

      if (conditions.isEmpty) {
        return await getAll();
      }

      String whereClause = conditions.join(' AND ');
      return await query(whereClause, arguments);
    } catch (e) {
      throw Exception('Error al buscar direcciones por criterios: $e');
    }
  }
}
