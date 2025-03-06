import 'package:zent/shared/models/employee_model.dart';
import '../../replace.dart'; // Importamos las utilidades de BD

EmployeeModel? select_employee_supabase(int id) {
  try {
    final supabase = getSupabaseClient();

    // Buscar empleado por ID
    final response =
        supabase.from('employees').select().eq('id', id).single().execute();

    // Si encontramos datos, los convertimos a un EmployeeModel
    if (response.data != null && response.data.isNotEmpty) {
      return EmployeeModel.fromJson(response.data);
    }

    return null;
  } catch (e) {
    logError('Error buscando empleado en Supabase: $e');
    return null;
  }
}

EmployeeModel? select_employee_sql(int id) {
  try {
    final db = getSQLiteDatabase();

    // Buscar empleado por ID
    final result = db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    // Si encontramos datos, los convertimos a un EmployeeModel
    if (result.isNotEmpty) {
      return EmployeeModel.fromJson(result.first);
    }

    return null;
  } catch (e) {
    logError('Error buscando empleado en SQLite: $e');
    return null;
  }
}

List<EmployeeModel> select_employees_supabase(int id) {
  List<EmployeeModel> employees = [];

  try {
    final supabase = getSupabaseClient();

    // Buscar empleados (puedes ajustar la consulta según tus necesidades)
    final response = supabase
        .from('employees')
        .select()
        // Si necesitas filtrar por algún campo relacionado con el id:
        // .eq('campo', id)
        .execute();

    if (response.data != null && response.data.isNotEmpty) {
      for (var item in response.data) {
        employees.add(EmployeeModel.fromJson(item));
      }
    }
  } catch (e) {
    logError('Error buscando empleados en Supabase: $e');
  }

  return employees;
}

List<EmployeeModel> select_employees_sql(int id) {
  List<EmployeeModel> employees = [];

  try {
    final db = getSQLiteDatabase();

    // Buscar empleados (puedes ajustar la consulta según tus necesidades)
    final result = db.query(
      'employees',
      // Si necesitas filtrar por algún campo:
      // where: 'campo = ?',
      // whereArgs: [id],
    );

    if (result.isNotEmpty) {
      for (var item in result) {
        employees.add(EmployeeModel.fromJson(item));
      }
    }
  } catch (e) {
    logError('Error buscando empleados en SQLite: $e');
  }

  return employees;
}
