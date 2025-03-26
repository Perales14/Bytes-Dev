import '../models/base_model.dart';
import '../models/proyecto_model.dart';
import 'base_repository.dart';

class ProyectoRepository extends BaseRepository<ProyectoModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  ProyectoRepository() : super(tableName: 'proyectos');

  @override
  ProyectoModel fromMap(Map<String, dynamic> map) {
    return ProyectoModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      clienteId: map['cliente_id'] ?? 0,
      responsableId: map['responsable_id'] ?? 0,
      proveedorId: map['proveedor_id'],
      fechaInicio: BaseModel.parseDateTime(map['fecha_inicio']),
      fechaFinEstimada: BaseModel.parseDateTime(map['fecha_fin_estimada']),
      fechaFinReal: BaseModel.parseDateTime(map['fecha_fin_real']),
      fechaEntrega: BaseModel.parseDateTime(map['fecha_entrega']),
      presupuestoEstimado: map['presupuesto_estimado'],
      costoReal: map['costo_real'],
      comisionPorcentaje: map['comision_porcentaje'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para proyectos

  // Método para obtener proyectos por cliente
  Future<List<ProyectoModel>> getByCliente(int clienteId) async {
    try {
      return await query('cliente_id = ?', [clienteId]);
    } catch (e) {
      throw Exception('Error al obtener proyectos por cliente: $e');
    }
  }

  // Método para obtener proyectos por responsable
  Future<List<ProyectoModel>> getByResponsable(int responsableId) async {
    try {
      return await query('responsable_id = ?', [responsableId]);
    } catch (e) {
      throw Exception('Error al obtener proyectos por responsable: $e');
    }
  }

  // Método para obtener proyectos por proveedor
  Future<List<ProyectoModel>> getByProveedor(int proveedorId) async {
    try {
      return await query('proveedor_id = ?', [proveedorId]);
    } catch (e) {
      throw Exception('Error al obtener proyectos por proveedor: $e');
    }
  }

  // Método para obtener proyectos por estado
  Future<List<ProyectoModel>> getByEstado(int estadoId) async {
    try {
      return await query('estado_id = ?', [estadoId]);
    } catch (e) {
      throw Exception('Error al obtener proyectos por estado: $e');
    }
  }

  // Método para obtener proyectos en progreso (sin fecha_fin_real)
  Future<List<ProyectoModel>> getProyectosEnProgreso() async {
    try {
      return await query(
          'fecha_fin_real IS NULL AND fecha_inicio IS NOT NULL', []);
    } catch (e) {
      throw Exception('Error al obtener proyectos en progreso: $e');
    }
  }
}
