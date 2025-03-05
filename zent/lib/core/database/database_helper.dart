import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zent/core/constants/db_constants.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = "zent.db";
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Tablas base sin dependencias
    await db.execute('''
      CREATE TABLE ${DbConstants.direccionesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        calle TEXT NOT NULL,
        numero TEXT NOT NULL,
        colonia TEXT NOT NULL,
        cp TEXT NOT NULL,
        estado TEXT,
        pais TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.especialidadesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.estadosTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        tabla TEXT NOT NULL,
        codigo TEXT NOT NULL,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        UNIQUE(tabla, codigo)
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.rolesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL UNIQUE,
        descripcion TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0
      );
    ''');

    // Tablas con dependencias básicas
    await db.execute('''
      CREATE TABLE ${DbConstants.usuariosTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        rol_id INTEGER NOT NULL,
        especialidad_id INTEGER,
        nombre_completo TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telefono TEXT,
        nss TEXT NOT NULL UNIQUE CHECK(length(nss) = 11),
        contrasena_hash TEXT NOT NULL,
        fecha_ingreso TEXT NOT NULL,
        salario REAL,
        tipo_contrato TEXT CHECK(tipo_contrato IN ('Temporal', 'Indefinido', 'Por Obra')),
        supervisor_id INTEGER,
        cargo TEXT,
        departamento TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        estado_id INTEGER NOT NULL,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(supervisor_id) REFERENCES ${DbConstants.usuariosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(estado_id) REFERENCES ${DbConstants.estadosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(especialidad_id) REFERENCES ${DbConstants.especialidadesTable}(${DbConstants.idColumn}),
        FOREIGN KEY(rol_id) REFERENCES ${DbConstants.rolesTable}(${DbConstants.idColumn})
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.clientesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_empresa TEXT,
        telefono TEXT,
        email TEXT UNIQUE,
        rfc TEXT UNIQUE,
        tipo TEXT CHECK(tipo IN ('Particular', 'Empresa', 'Gobierno')),
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        nombre TEXT NOT NULL,
        apellido_paterno TEXT NOT NULL,
        apellido_materno TEXT,
        id_direccion INTEGER,
        estado_id INTEGER NOT NULL,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(id_direccion) REFERENCES ${DbConstants.direccionesTable}(${DbConstants.idColumn}),
        FOREIGN KEY(estado_id) REFERENCES ${DbConstants.estadosTable}(${DbConstants.idColumn}),
        CHECK(telefono IS NOT NULL OR email IS NOT NULL)
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.proveedoresTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        especialidad_id INTEGER NOT NULL,
        nombre_empresa TEXT NOT NULL,
        contacto_principal TEXT,
        telefono TEXT,
        email TEXT UNIQUE,
        rfc TEXT UNIQUE,
        tipo_servicio TEXT,
        condiciones_pago TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        id_direccion INTEGER,
        estado_id INTEGER NOT NULL,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(id_direccion) REFERENCES ${DbConstants.direccionesTable}(${DbConstants.idColumn}),
        FOREIGN KEY(estado_id) REFERENCES ${DbConstants.estadosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(especialidad_id) REFERENCES ${DbConstants.especialidadesTable}(${DbConstants.idColumn})
      );
    ''');

    // Tablas con dependencias complejas
    await db.execute('''
      CREATE TABLE ${DbConstants.proyectosTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        cliente_id INTEGER NOT NULL,
        responsable_id INTEGER NOT NULL,
        proveedor_id INTEGER,
        fecha_inicio TEXT,
        fecha_fin_estimada TEXT,
        fecha_fin_real TEXT,
        fecha_entrega TEXT,
        presupuesto_estimado REAL,
        costo_real REAL,
        comision_porcentaje REAL,
        comision_consultoria REAL,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        id_direccion INTEGER,
        estado_id INTEGER NOT NULL,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(id_direccion) REFERENCES ${DbConstants.direccionesTable}(${DbConstants.idColumn}),
        FOREIGN KEY(estado_id) REFERENCES ${DbConstants.estadosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(cliente_id) REFERENCES ${DbConstants.clientesTable}(${DbConstants.idColumn}),
        FOREIGN KEY(proveedor_id) REFERENCES ${DbConstants.proveedoresTable}(${DbConstants.idColumn}),
        FOREIGN KEY(responsable_id) REFERENCES ${DbConstants.usuariosTable}(${DbConstants.idColumn})
      );
    ''');

    // Tablas dependientes de proyectos
    await db.execute('''
      CREATE TABLE ${DbConstants.actividadesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        proyecto_id INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        responsable_id INTEGER,
        fecha_inicio TEXT,
        fecha_fin TEXT,
        dependencia_id INTEGER,
        evidencias TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        estado_id INTEGER NOT NULL,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(dependencia_id) REFERENCES ${DbConstants.actividadesTable}(${DbConstants.idColumn}),
        FOREIGN KEY(proyecto_id) REFERENCES ${DbConstants.proyectosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(responsable_id) REFERENCES ${DbConstants.usuariosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(estado_id) REFERENCES ${DbConstants.estadosTable}(${DbConstants.idColumn})
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.documentosTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        proyecto_id INTEGER,
        tipo TEXT CHECK(tipo IN ('Contrato', 'Factura', 'Reporte', 'Incidente', 'Avance')),
        titulo TEXT NOT NULL,
        contenido TEXT,
        archivo_url TEXT,
        usuario_id INTEGER NOT NULL,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(proyecto_id) REFERENCES ${DbConstants.proyectosTable}(${DbConstants.idColumn}),
        FOREIGN KEY(usuario_id) REFERENCES ${DbConstants.usuariosTable}(${DbConstants.idColumn})
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.incidentesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        proyecto_id INTEGER NOT NULL,
        tipo TEXT CHECK(tipo IN ('Accidente', 'Retraso', 'Falla Técnica', 'Otro')),
        descripcion TEXT NOT NULL,
        impacto TEXT CHECK(impacto IN ('Bajo', 'Medio', 'Alto')),
        acciones TEXT,
        estado TEXT CHECK(estado IN ('Abierto', 'En Proceso', 'Resuelto')),
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(proyecto_id) REFERENCES ${DbConstants.proyectosTable}(${DbConstants.idColumn})
      );
    ''');

    // Tablas de auditoría y misceláneos
    await db.execute('''
      CREATE TABLE ${DbConstants.auditoriaTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        tabla_afectada TEXT NOT NULL,
        operacion TEXT CHECK(operacion IN ('INSERT', 'UPDATE', 'DELETE')),
        id_afectado INTEGER,
        valores_anteriores TEXT,
        valores_nuevos TEXT,
        usuario_id INTEGER,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(usuario_id) REFERENCES ${DbConstants.usuariosTable}(${DbConstants.idColumn})
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.observacionesTable} (
        ${DbConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        tabla_origen TEXT NOT NULL,
        id_origen INTEGER NOT NULL,
        observacion TEXT NOT NULL,
        usuario_id INTEGER NOT NULL,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(usuario_id) REFERENCES ${DbConstants.usuariosTable}(${DbConstants.idColumn})
      );
    ''');

    await db.execute('''
      CREATE TABLE ${DbConstants.permisosTable} (
        rol_id INTEGER PRIMARY KEY,
        permisos_json TEXT,
        ${DbConstants.createdAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.updatedAtColumn} TEXT DEFAULT CURRENT_TIMESTAMP,
        ${DbConstants.enviadoColumn} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(rol_id) REFERENCES ${DbConstants.rolesTable}(${DbConstants.idColumn})
      );
    ''');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Manejar cambios en el esquema cuando se actualiza la versión
  }

  // Métodos de utilidad para timestamp
  static String getCurrentTimestamp() {
    return DateTime.now().toIso8601String();
  }
}
