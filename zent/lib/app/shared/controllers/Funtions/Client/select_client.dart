import 'package:zent/app/shared/models/client_model.dart';
import '../../replace.dart'; // Asumiendo que aquí están tus utilidades de BD

ClientModel? select_client_supabase(int id) {
  try {
    final supabase = getSupabaseClient();

    // Buscar cliente por ID
    final response =
        supabase.from('clients').select().eq('id', id).single().execute();

    // Si encontramos datos, los convertimos a un ClientModel
    if (response.data != null && response.data.isNotEmpty) {
      return ClientModel.fromJson(response.data);
    }

    return null;
  } catch (e) {
    logError('Error buscando cliente en Supabase: $e');
    return null;
  }
}

ClientModel? select_client_sql(int id) {
  try {
    final db = getSQLiteDatabase();

    // Buscar cliente por ID
    final result = db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    // Si encontramos datos, los convertimos a un ClientModel
    if (result.isNotEmpty) {
      return ClientModel.fromJson(result.first);
    }

    return null;
  } catch (e) {
    logError('Error buscando cliente en SQLite: $e');
    return null;
  }
}

List<ClientModel> select_clients_supabase(int id) {
  List<ClientModel> clients = [];

  try {
    final supabase = getSupabaseClient();

    // Buscar clientes (asumiendo que se filtra por algún campo relacionado con el id)
    // Nota: Normalmente select_clients buscaría todos o aplicaría otro filtro
    final response = supabase
        .from('clients')
        .select()
        // Aquí puedes agregar filtros según tus necesidades
        .execute();

    if (response.data != null && response.data.isNotEmpty) {
      for (var item in response.data) {
        clients.add(ClientModel.fromJson(item));
      }
    }
  } catch (e) {
    logError('Error buscando clientes en Supabase: $e');
  }

  return clients;
}

List<ClientModel> select_clients_sql(int id) {
  List<ClientModel> clients = [];

  try {
    final db = getSQLiteDatabase();

    // Buscar clientes (asumiendo que se filtra por algún campo relacionado con el id)
    final result = db.query(
      'clients',
      // Aquí puedes agregar filtros según tus necesidades
    );

    if (result.isNotEmpty) {
      for (var item in result) {
        clients.add(ClientModel.fromJson(item));
      }
    }
  } catch (e) {
    logError('Error buscando clientes en SQLite: $e');
  }

  return clients;
}

// ------------------------
// Utilidades necesarias
// ------------------------

// Las mismas utilidades de save_client
