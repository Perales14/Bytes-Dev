import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../../utils/db_constants.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper._internal();
  static Database? _database;
  static bool _initialized = false;

  factory SQLiteHelper() {
    return _instance;
  }

  SQLiteHelper._internal();

  /// Initialize the database factory based on platform
  Future<void> initializeDatabaseFactory() async {
    if (_initialized) return;

    // Initialize FFI for desktop platforms
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // Initialize FFI
      sqfliteFfiInit();
      // Override default factory
      databaseFactory = databaseFactoryFfi;
    }

    _initialized = true;
  }

  Future<Database> get database async {
    // Ensure database factory is initialized first
    await initializeDatabaseFactory();

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
    // Crear índices después de las tablas para mejorar el rendimiento
    await _executeQueries(db, DBConstants.CREATE_INDICES_QUERIES);
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
