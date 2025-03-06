import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../utils/db_constants.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper._internal();
  static Database? _database;

  factory SQLiteHelper() {
    return _instance;
  }

  SQLiteHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), DBConstants.DATABASE_NAME);
    return await openDatabase(
      path,
      version: DBConstants.DATABASE_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crear todas las tablas basadas en las constantes
    await _executeQueries(db, DBConstants.CREATE_TABLES_QUERIES);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Lógica para migraciones de base de datos
    if (oldVersion < newVersion) {
      // Puedes implementar migraciones específicas según la versión
      // Por ejemplo: if (oldVersion == 1 && newVersion == 2) { ... }
    }
  }

  Future<void> _executeQueries(Database db, List<String> queries) async {
    for (String query in queries) {
      await db.execute(query);
    }
  }
}
