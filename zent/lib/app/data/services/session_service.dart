import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

/// Servicio para gestionar la sesión del usuario en la aplicación
class SessionService extends GetxService {
  final _box = GetStorage();
  final RxBool _isAuthenticated = false.obs;
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  // Clave para almacenar datos de usuario en GetStorage
  static const String _userKey = 'current_user';

  // Definición de roles del sistema
  static const int ROLE_ADMIN = 1;
  static const int ROLE_PROMOTOR = 2;
  static const int ROLE_CAPTADOR = 3;
  static const int ROLE_RRHH = 4;

  /// Indica si hay un usuario autenticado
  bool get isAuthenticated => _isAuthenticated.value;

  /// Obtiene el usuario actual autenticado
  UserModel? get currentUser => _currentUser.value;

  /// Obtiene el rol del usuario actual como string descriptivo
  String get userRole {
    if (_currentUser.value == null) return '';

    // Mapeo de IDs de roles a nombres (según los valores reales)
    switch (_currentUser.value!.roleId) {
      case ROLE_ADMIN:
        return 'Administrador';
      case ROLE_PROMOTOR:
        return 'Promotor';
      case ROLE_CAPTADOR:
        return 'Captador de campo';
      case ROLE_RRHH:
        return 'Recursos Humanos';
      default:
        return 'Usuario';
    }
  }

  /// Verifica si el usuario tiene un rol específico
  bool hasRole(int roleId) {
    return _currentUser.value?.roleId == roleId;
  }

  /// Verifica si el usuario tiene alguno de los roles especificados
  bool hasAnyRole(List<int> roleIds) {
    if (_currentUser.value == null) return false;
    return roleIds.contains(_currentUser.value!.roleId);
  }

  @override
  void onInit() {
    super.onInit();
    // Cargar datos del usuario si existe una sesión previa
    _loadUserFromStorage();
  }

  /// Carga los datos de usuario almacenados localmente
  void _loadUserFromStorage() {
    try {
      final userData = _box.read(_userKey);
      if (userData != null) {
        _currentUser.value = UserModel.fromJson(userData);
        _isAuthenticated.value = true;
      }
    } catch (e) {
      // Si hay algún error al cargar los datos, cerrar la sesión
      logout();
      print('Error al cargar datos de usuario: $e');
    }
  }

  /// Inicia sesión y almacena datos del usuario
  ///
  /// [user] Modelo del usuario autenticado
  Future<void> login(UserModel user) async {
    try {
      _currentUser.value = user;
      _isAuthenticated.value = true;

      // Guardar en almacenamiento local
      await _box.write(_userKey, user.toMap());
    } catch (e) {
      print('Error al guardar datos de sesión: $e');
      throw Exception('Error al iniciar sesión');
    }
  }

  /// Cierra la sesión y elimina los datos del usuario
  Future<void> logout() async {
    _isAuthenticated.value = false;
    _currentUser.value = null;
    await _box.remove(_userKey);
  }
}
