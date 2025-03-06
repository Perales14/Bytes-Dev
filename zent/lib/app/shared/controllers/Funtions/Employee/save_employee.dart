import 'package:zent/app/shared/models/employee_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

bool save_employee_sql(EmployeeModel employee) {
  try {
    final db = getSQLiteDatabase();

    // Convertir el empleado a un mapa para almacenarlo
    final employeeMap = employee.toMap();

    // Si el empleado tiene ID, actualizar, si no, insertar
    if (employee.id != null && employee.id!.isNotEmpty) {
      db.update('employees', employeeMap,
          where: 'id = ?', whereArgs: [employee.id]);
    } else {
      final newId = db.insert('employees', employeeMap);
      // Actualizar el ID del cliente con el generado
      // employee = employee.copyWith(id: newId.toString());
    }

    return true;
  } catch (e) {
    logError('Error guardando empleado en SQLite: $e');
    return false;
  }
}

bool save_employee_supabase(EmployeeModel employee) {
  try {
    final supabase = getSupabaseClient();

    // Convertir el empleado a un mapa para almacenarlo
    final employeeMap = employee.toMap();

    // Si el empleado tiene ID, actualizar, si no, insertar
    if (employee.id != null && employee.id!.isNotEmpty) {
      supabase
          .from('employees')
          .update(employeeMap)
          .eq('id', employee.id)
          .execute();
    } else {
      final response = supabase.from('employees').insert(employeeMap).execute();

      // Actualizar el ID del empleado con el generado por Supabase
      if (response.data != null && response.data.isNotEmpty) {
        // employee = employee.copyWith(id: response.data[0]['id']);
      }
    }

    return true;
  } catch (e) {
    logError('Error guardando empleado en Supabase: $e');
    return false;
  }
}
