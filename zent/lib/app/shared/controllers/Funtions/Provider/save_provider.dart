import 'package:zent/shared/models/provider_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

bool save_provider_sql(ProviderModel provider) {
  try {
    final db = getSQLiteDatabase();

    // Convertir el proveedor a un mapa para almacenarlo
    final providerMap = provider.toMap();

    // Si el proveedor tiene ID, actualizar, si no, insertar
    if (provider.id != null && provider.id!.isNotEmpty) {
      db.update('providers', providerMap,
          where: 'id = ?', whereArgs: [provider.id]);
    } else {
      final newId = db.insert('providers', providerMap);
      // Si se necesita actualizar el ID del proveedor con el generado:
      // provider = provider.copyWith(id: newId.toString());
    }

    return true;
  } catch (e) {
    logError('Error guardando proveedor en SQLite: $e');
    return false;
  }
}

bool save_provider_supabase(ProviderModel provider) {
  try {
    final supabase = getSupabaseClient();

    // Convertir el proveedor a un mapa para almacenarlo
    final providerMap = provider.toMap();

    // Si el proveedor tiene ID, actualizar, si no, insertar
    if (provider.id != null && provider.id!.isNotEmpty) {
      supabase
          .from('providers')
          .update(providerMap)
          .eq('id', provider.id)
          .execute();
    } else {
      final response = supabase.from('providers').insert(providerMap).execute();

      // Actualizar el ID del proveedor con el generado por Supabase
      if (response.data != null && response.data.isNotEmpty) {
        // provider = provider.copyWith(id: response.data[0]['id']);
      }
    }

    return true;
  } catch (e) {
    logError('Error guardando proveedor en Supabase: $e');
    return false;
  }
}
