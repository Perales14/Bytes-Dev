import 'package:zent/shared/models/provider_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

bool delete_provider_sql(ProviderModel provider) {
  try {
    final db = getSQLiteDatabase();

    // Verificar que el proveedor tenga un ID
    if (provider.id == null) {
      logError('Error eliminando proveedor en SQLite: ID es null');
      return false;
    }

    // Eliminar el proveedor por ID
    final rowsAffected = db.delete(
      'providers',
      where: 'id = ?',
      whereArgs: [provider.id],
    );

    // Verificar si se eliminó correctamente
    return rowsAffected > 0;
  } catch (e) {
    logError('Error eliminando proveedor en SQLite: $e');
    return false;
  }
}

bool delete_provider_supabase(ProviderModel provider) {
  try {
    final supabase = getSupabaseClient();

    // Verificar que el proveedor tenga un ID
    if (provider.id == null) {
      logError('Error eliminando proveedor en Supabase: ID es null');
      return false;
    }

    // Eliminar el proveedor por ID
    supabase.from('providers').delete().eq('id', provider.id).execute();

    // Asumimos éxito si no hay excepciones
    return true;
  } catch (e) {
    logError('Error eliminando proveedor en Supabase: $e');
    return false;
  }
}
