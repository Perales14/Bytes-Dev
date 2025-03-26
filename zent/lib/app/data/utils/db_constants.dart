class DBConstants {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 1;

  // Definiciones de tablas
  static const List<String> CREATE_TABLES_QUERIES = [
    // Tabla Direcciones
    '''
    CREATE TABLE IF NOT EXISTS direcciones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      calle TEXT NOT NULL,
      numero TEXT NOT NULL,
      colonia TEXT NOT NULL,
      cp TEXT NOT NULL,
      estado TEXT,
      pais TEXT,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0
    )
    ''',

    // Tabla Especialidades
    '''
    CREATE TABLE IF NOT EXISTS especialidades (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL UNIQUE,
      descripcion TEXT,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0
    )
    ''',

    // Tabla Estados
    '''
    CREATE TABLE IF NOT EXISTS estados (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tabla TEXT NOT NULL,
      codigo TEXT NOT NULL,
      nombre TEXT NOT NULL,
      descripcion TEXT,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      UNIQUE(tabla, codigo)
    )
    ''',

    // Tabla Roles
    '''
    CREATE TABLE IF NOT EXISTS roles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL UNIQUE,
      descripcion TEXT,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0
    )
    ''',

    // Tabla Usuarios
    '''
    CREATE TABLE IF NOT EXISTS usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      rol_id INTEGER NOT NULL,
      especialidad_id INTEGER,
      nombre_completo TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      telefono TEXT,
      nss TEXT NOT NULL UNIQUE,
      contrasena_hash TEXT NOT NULL,
      fecha_ingreso TEXT NOT NULL,
      salario REAL,
      tipo_contrato TEXT CHECK(tipo_contrato IN ('Temporal', 'Indefinido', 'Por Obra')),
      supervisor_id INTEGER,
      cargo TEXT,
      departamento TEXT,
      estado_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (rol_id) REFERENCES roles (id),
      FOREIGN KEY (especialidad_id) REFERENCES especialidades (id),
      FOREIGN KEY (supervisor_id) REFERENCES usuarios (id),
      FOREIGN KEY (estado_id) REFERENCES estados (id)
    )
    ''',

    // Tabla Clientes
    '''
    CREATE TABLE IF NOT EXISTS clientes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      apellido_paterno TEXT NOT NULL,
      apellido_materno TEXT,
      nombre_empresa TEXT,
      telefono TEXT,
      email TEXT UNIQUE,
      rfc TEXT UNIQUE,
      tipo TEXT CHECK(tipo IN ('Particular', 'Empresa', 'Gobierno')),
      id_direccion INTEGER,
      estado_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (id_direccion) REFERENCES direcciones (id),
      FOREIGN KEY (estado_id) REFERENCES estados (id),
      CHECK(telefono IS NOT NULL OR email IS NOT NULL)
    )
    ''',

    // Tabla Proveedores
    '''
    CREATE TABLE IF NOT EXISTS proveedores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      especialidad_id INTEGER NOT NULL,
      nombre_empresa TEXT NOT NULL,
      contacto_principal TEXT,
      telefono TEXT,
      email TEXT UNIQUE,
      rfc TEXT UNIQUE,
      tipo_servicio TEXT,
      condiciones_pago TEXT,
      id_direccion INTEGER,
      estado_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (especialidad_id) REFERENCES especialidades (id),
      FOREIGN KEY (id_direccion) REFERENCES direcciones (id),
      FOREIGN KEY (estado_id) REFERENCES estados (id)
    )
    ''',

    // Tabla Proyectos
    '''
    CREATE TABLE IF NOT EXISTS proyectos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
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
      id_direccion INTEGER,
      estado_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (cliente_id) REFERENCES clientes (id),
      FOREIGN KEY (responsable_id) REFERENCES usuarios (id),
      FOREIGN KEY (proveedor_id) REFERENCES proveedores (id),
      FOREIGN KEY (id_direccion) REFERENCES direcciones (id),
      FOREIGN KEY (estado_id) REFERENCES estados (id)
    )
    ''',

    // Tabla Actividades
    '''
    CREATE TABLE IF NOT EXISTS actividades (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      proyecto_id INTEGER NOT NULL,
      descripcion TEXT NOT NULL,
      responsable_id INTEGER,
      fecha_inicio TEXT,
      fecha_fin TEXT,
      dependencia_id INTEGER,
      estado_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (proyecto_id) REFERENCES proyectos (id),
      FOREIGN KEY (responsable_id) REFERENCES usuarios (id),
      FOREIGN KEY (dependencia_id) REFERENCES actividades (id),
      FOREIGN KEY (estado_id) REFERENCES estados (id)
    )
    ''',

    // Tabla para almacenar evidencias de actividades (como alternativa a TEXT[] de PostgreSQL)
    '''
    CREATE TABLE IF NOT EXISTS actividades_evidencias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      actividad_id INTEGER NOT NULL,
      evidencia TEXT NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (actividad_id) REFERENCES actividades (id)
    )
    ''',

    // Tabla Documentos
    '''
    CREATE TABLE IF NOT EXISTS documentos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      proyecto_id INTEGER,
      tipo TEXT CHECK(tipo IN ('Contrato', 'Factura', 'Reporte', 'Incidente', 'Avance')),
      titulo TEXT NOT NULL,
      contenido TEXT,
      archivo_url TEXT,
      usuario_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (proyecto_id) REFERENCES proyectos (id),
      FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
    )
    ''',

    // Tabla Incidentes
    '''
    CREATE TABLE IF NOT EXISTS incidentes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      proyecto_id INTEGER NOT NULL,
      tipo TEXT CHECK(tipo IN ('Accidente', 'Retraso', 'Falla Técnica', 'Otro')),
      descripcion TEXT NOT NULL,
      impacto TEXT CHECK(impacto IN ('Bajo', 'Medio', 'Alto')),
      acciones TEXT,
      estado TEXT CHECK(estado IN ('Abierto', 'En Proceso', 'Resuelto')),
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (proyecto_id) REFERENCES proyectos (id)
    )
    ''',

    // Tabla Auditoria
    '''
    CREATE TABLE IF NOT EXISTS auditoria (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tabla_afectada TEXT NOT NULL,
      operacion TEXT CHECK(operacion IN ('INSERT', 'UPDATE', 'DELETE')),
      id_afectado INTEGER,
      valores_anteriores TEXT, -- JSON en SQLite como TEXT
      valores_nuevos TEXT, -- JSON en SQLite como TEXT
      usuario_id INTEGER,
      created_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
    )
    ''',

    // Tabla Observaciones
    '''
    CREATE TABLE IF NOT EXISTS observaciones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tabla_origen TEXT NOT NULL,
      id_origen INTEGER NOT NULL,
      observacion TEXT NOT NULL,
      usuario_id INTEGER NOT NULL,
      created_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
    )
    ''',

    // Tabla Permisos
    '''
    CREATE TABLE IF NOT EXISTS permisos (
      rol_id INTEGER PRIMARY KEY,
      permisos_json TEXT, -- JSON en SQLite como TEXT
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now')),
      enviado INTEGER DEFAULT 0,
      FOREIGN KEY (rol_id) REFERENCES roles (id)
    )
    '''
  ];

  // Índices para mejorar rendimiento
  static const List<String> CREATE_INDICES_QUERIES = [
    // Direcciones
    'CREATE INDEX IF NOT EXISTS idx_direcciones_cp ON direcciones (cp)',

    // Usuarios
    'CREATE INDEX IF NOT EXISTS idx_usuarios_rol ON usuarios (rol_id)',
    'CREATE INDEX IF NOT EXISTS idx_usuarios_especialidad ON usuarios (especialidad_id)',
    'CREATE INDEX IF NOT EXISTS idx_usuarios_supervisor ON usuarios (supervisor_id)',
    'CREATE INDEX IF NOT EXISTS idx_usuarios_estado ON usuarios (estado_id)',

    // Clientes
    'CREATE INDEX IF NOT EXISTS idx_clientes_direccion ON clientes (id_direccion)',
    'CREATE INDEX IF NOT EXISTS idx_clientes_estado ON clientes (estado_id)',

    // Proveedores
    'CREATE INDEX IF NOT EXISTS idx_proveedores_especialidad ON proveedores (especialidad_id)',
    'CREATE INDEX IF NOT EXISTS idx_proveedores_direccion ON proveedores (id_direccion)',
    'CREATE INDEX IF NOT EXISTS idx_proveedores_estado ON proveedores (estado_id)',

    // Proyectos
    'CREATE INDEX IF NOT EXISTS idx_proyectos_cliente ON proyectos (cliente_id)',
    'CREATE INDEX IF NOT EXISTS idx_proyectos_responsable ON proyectos (responsable_id)',
    'CREATE INDEX IF NOT EXISTS idx_proyectos_proveedor ON proyectos (proveedor_id)',
    'CREATE INDEX IF NOT EXISTS idx_proyectos_direccion ON proyectos (id_direccion)',
    'CREATE INDEX IF NOT EXISTS idx_proyectos_estado ON proyectos (estado_id)',

    // Actividades
    'CREATE INDEX IF NOT EXISTS idx_actividades_proyecto ON actividades (proyecto_id)',
    'CREATE INDEX IF NOT EXISTS idx_actividades_responsable ON actividades (responsable_id)',
    'CREATE INDEX IF NOT EXISTS idx_actividades_dependencia ON actividades (dependencia_id)',
    'CREATE INDEX IF NOT EXISTS idx_actividades_estado ON actividades (estado_id)',

    // Evidencias
    'CREATE INDEX IF NOT EXISTS idx_evidencias_actividad ON actividades_evidencias (actividad_id)',

    // Documentos
    'CREATE INDEX IF NOT EXISTS idx_documentos_proyecto ON documentos (proyecto_id)',
    'CREATE INDEX IF NOT EXISTS idx_documentos_usuario ON documentos (usuario_id)',
    'CREATE INDEX IF NOT EXISTS idx_documentos_tipo ON documentos (tipo)',

    // Incidentes
    'CREATE INDEX IF NOT EXISTS idx_incidentes_proyecto ON incidentes (proyecto_id)',
    'CREATE INDEX IF NOT EXISTS idx_incidentes_estado ON incidentes (estado)',

    // Auditoria
    'CREATE INDEX IF NOT EXISTS idx_auditoria_tabla ON auditoria (tabla_afectada)',
    'CREATE INDEX IF NOT EXISTS idx_auditoria_usuario ON auditoria (usuario_id)',

    // Observaciones
    'CREATE INDEX IF NOT EXISTS idx_observaciones_origen ON observaciones (tabla_origen, id_origen)',
    'CREATE INDEX IF NOT EXISTS idx_observaciones_usuario ON observaciones (usuario_id)'
  ];
}
