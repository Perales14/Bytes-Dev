import 'package:zent/shared/models/client_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

bool delete_client_sql(ClientModel cliente) {
  try {
    final db = getSQLiteDatabase();

    // Verificar que el cliente tenga un ID
    if (cliente.id == null) {
      logError('Error eliminando cliente en SQLite: ID es null');
      return false;
    }

    // Eliminar el cliente por ID
    final rowsAffected = db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [cliente.id],
    );

    // Verificar si se eliminó correctamente
    return rowsAffected > 0;
  } catch (e) {
    logError('Error eliminando cliente en SQLite: $e');
    return false;
  }
}

bool delete_client_supabase(ClientModel cliente) {
  try {
    final supabase = getSupabaseClient();

    // Verificar que el cliente tenga un ID
    if (cliente.id == null) {
      logError('Error eliminando cliente en Supabase: ID es null');
      return false;
    }

    // Eliminar el cliente por ID
    supabase.from('clients').delete().eq('id', cliente.id).execute();

    // Asumimos éxito si no hay excepciones
    return true;
  } catch (e) {
    logError('Error eliminando cliente en Supabase: $e');
    return false;
  }
}
