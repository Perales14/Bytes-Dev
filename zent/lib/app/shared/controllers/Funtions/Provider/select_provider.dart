import 'package:zent/app/shared/models/provider_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

ProviderModel? select_provider_supabase(int id) {
  try {
    final supabase = getSupabaseClient();

    // Buscar proveedor por ID
    final response =
        supabase.from('providers').select().eq('id', id).single().execute();

    // Si encontramos datos, los convertimos a un ProviderModel
    if (response.data != null && response.data.isNotEmpty) {
      return ProviderModel.fromJson(response.data);
    }

    return null;
  } catch (e) {
    logError('Error buscando proveedor en Supabase: $e');
    return null;
  }
}

ProviderModel? select_provider_sql(int id) {
  try {
    final db = getSQLiteDatabase();

    // Buscar proveedor por ID
    final result = db.query(
      'providers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    // Si encontramos datos, los convertimos a un ProviderModel
    if (result.isNotEmpty) {
      return ProviderModel.fromJson(result.first);
    }

    return null;
  } catch (e) {
    logError('Error buscando proveedor en SQLite: $e');
    return null;
  }
}

List<ProviderModel> select_providers_supabase(int id) {
  List<ProviderModel> providers = [];

  try {
    final supabase = getSupabaseClient();

    // Buscar proveedores (puedes ajustar la consulta según tus necesidades)
    final response = supabase
        .from('providers')
        .select()
        // .eq('campo_relacionado', id)  // Si necesitas filtrar por algún criterio
        .execute();

    if (response.data != null && response.data.isNotEmpty) {
      for (var item in response.data) {
        providers.add(ProviderModel.fromJson(item));
      }
    }
  } catch (e) {
    logError('Error buscando proveedores en Supabase: $e');
  }

  return providers;
}

List<ProviderModel> select_providers_sql(int id) {
  List<ProviderModel> providers = [];

  try {
    final db = getSQLiteDatabase();

    // Buscar proveedores (puedes ajustar la consulta según tus necesidades)
    final result = db.query(
      'providers',
      // where: 'campo_relacionado = ?',  // Si necesitas filtrar
      // whereArgs: [id],
    );

    if (result.isNotEmpty) {
      for (var item in result) {
        providers.add(ProviderModel.fromJson(item));
      }
    }
  } catch (e) {
    logError('Error buscando proveedores en SQLite: $e');
  }

  return providers;
}
