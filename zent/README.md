## Estructura del Proyecto

```
lib/
│
├── core/  # Configuraciones y utilidades globales
│   ├── bindings/
│   │   └── initial_bindings.dart  # Vincula los controladores principales
│   ├── routes/
│   │   ├── app_pages.dart  # Definición de rutas
│   │   └── app_routes.dart  # Nombres de las rutas
│   ├── theme/
│   │   └── app_theme.dart  # Tema general de la aplicación
│   ├── utils/
│   │   ├── constants.dart  # Constantes globales
│   │   └── helpers.dart  # Funciones utilitarias
│
├── data/  # Manejo de bases de datos y sincronización
│   ├── local/
│   │   ├── db_helper.dart  # Configuración y manejo de SQLite
│   │   └── local_repository.dart  # Operaciones en la base de datos local
│   ├── remote/
│   │   ├── supabase_client.dart  # Configuración de Supabase
│   │   └── remote_repository.dart  # Operaciones en la base de datos en la nube
│   ├── repositories/
│   │   └── sync_repository.dart  # Lógica de sincronización entre local y remoto
│
├── models/  # Definición de modelos de datos
│   ├── usuario_model.dart
│   ├── proyecto_model.dart
│   ├── cliente_model.dart
│   └── observacion_model.dart
│
├── modules/  # Módulos separados por rol de usuario
│   ├── admin/
│   │   ├── controllers/
│   │   │   └── admin_controller.dart
│   │   ├── views/
│   │   │   └── admin_dashboard.dart
│   │   └── bindings/
│   │       └── admin_binding.dart
│   │
│   ├── rrhh/
│   │   ├── controllers/
│   │   │   └── rrhh_controller.dart
│   │   ├── views/
│   │   │   └── rrhh_dashboard.dart
│   │   └── bindings/
│   │       └── rrhh_binding.dart
│   │
│   ├── promotor/
│   │   ├── controllers/
│   │   │   └── promotor_controller.dart
│   │   ├── views/
│   │   │   └── promotor_dashboard.dart
│   │   └── bindings/
│   │       └── promotor_binding.dart
│   │
│   ├── captador_campo/
│   │   ├── controllers/
│   │   │   └── captador_controller.dart
│   │   ├── views/
│   │   │   └── captador_dashboard.dart
│   │   └── bindings/
│   │       └── captador_binding.dart
│
├── shared/  # Recursos reutilizables
│   ├── widgets/
│   │   ├── common_card.dart  # Tarjeta reutilizable
│   │   ├── custom_button.dart  # Botones personalizados
│   │   └── loading_indicator.dart  # Indicadores de carga
│   ├── dialogs/
│   │   └── confirmation_dialog.dart  # Diálogos de confirmación
│   └── styles/
│       └── text_styles.dart  # Estilos de texto globales
│
├── controllers/  # Controladores globales
│   ├── permissions_controller.dart  # Manejo de permisos por rol
│   ├── auth_controller.dart  # Control de autenticación
│   └── sync_controller.dart  # Controlador de sincronización (triggers automáticos)
│
├── services/  # Servicios de backend, APIs o notificaciones
│   ├── notification_service.dart  # Notificaciones locales o push
│   └── connectivity_service.dart  # Verificación de conexión a Internet
│
├── main.dart  # Punto de entrada principal
```