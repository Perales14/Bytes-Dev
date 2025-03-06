import 'package:zent/shared/models/employee_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

bool delete_employee_sql(EmployeeModel employee) {
  try {
    final db = getSQLiteDatabase();

    // Verificar que el empleado tenga un ID
    if (employee.id == null) {
      logError('Error eliminando empleado en SQLite: ID es null');
      return false;
    }

    // Eliminar el empleado por ID
    final rowsAffected = db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [employee.id],
    );

    // Verificar si se eliminó correctamente
    return rowsAffected > 0;
  } catch (e) {
    logError('Error eliminando empleado en SQLite: $e');
    return false;
  }
}

bool delete_employee_supabase(EmployeeModel employee) {
  try {
    final supabase = getSupabaseClient();

    // Verificar que el empleado tenga un ID
    if (employee.id == null) {
      logError('Error eliminando empleado en Supabase: ID es null');
      return false;
    }

    // Eliminar el empleado por ID
    supabase.from('employees').delete().eq('id', employee.id).execute();

    // Asumimos éxito si no hay excepciones
    return true;
  } catch (e) {
    logError('Error eliminando empleado en Supabase: $e');
    return false;
  }
}
