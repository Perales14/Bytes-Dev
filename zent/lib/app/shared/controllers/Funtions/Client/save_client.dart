import 'package:zent/shared/models/client_model.dart';

bool save_client_sqlflite(ClientModel cliente) {
  try {
    final db = getSQLiteDatabase();

    // Convertir el cliente a un mapa para almacenarlo
    final clienteMap = cliente.toMap();
    String b = '2';
    int a = b as int;

    // Si el cliente tiene ID, actualizar, si no, insertar
    if (cliente.id != null && cliente.id! as int > 0) {
      db.update('clients', clienteMap,
          where: 'id = ?', whereArgs: [cliente.id]);
    } else {
      cliente = cliente.copyWith(id: db.insert('clients', clienteMap));
      // cliente.id = db.insert('clients', clienteMap);
    }

    return true;
  } catch (e) {
    logError('Error guardando cliente en SQLite: $e');
    return false;
  }
}

bool save_client_supabase(ClientModel cliente) {
  try {
    final supabase = getSupabaseClient();

    // Convertir el cliente a un mapa para almacenarlo
    final clienteMap = cliente.toMap();

    // Si el cliente tiene ID, actualizar, si no, insertar
    if (cliente.id != null && cliente.id! as int > 0) {
      supabase
          .from('clients')
          .update(clienteMap)
          .eq('id', cliente.id)
          .execute();
    } else {
      final response = supabase.from('clients').insert(clienteMap).execute();

      // Actualizar el ID del cliente con el generado por Supabase
      if (response.data != null && response.data.isNotEmpty) {
        // cliente.id = response.data[0]['id'];
        cliente = cliente.copyWith(id: response.data[0]['id']);
      }
    }

    return true;
  } catch (e) {
    logError('Error guardando cliente en Supabase: $e');
    return false;
  }
}

// ------------------------
// Utilidades necesarias
// ------------------------

// Para SQLite
dynamic getSQLiteDatabase() {
  // Esta función debería retornar una instancia de la base de datos SQLite
  // Aquí iría la lógica de conexión a la base de datos
}

// Para Supabase
dynamic getSupabaseClient() {
  // Esta función debería retornar una instancia del cliente de Supabase
  // Aquí iría la lógica de conexión a Supabase
}

// Función de logging
void logError(String message) {
  // Implementar logging según el sistema que uses
  print(message);
}
