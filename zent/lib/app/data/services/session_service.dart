import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class SessionService extends GetxService {
  final _box = GetStorage();
  final RxBool _isAuthenticated = false.obs;
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  // Servicio de usuario para verificar estado
  late final UserService _userService;

  static const String _userKey = 'current_user';

  // Roles del sistema
  static const int ROLE_ADMIN = 1;
  static const int ROLE_PROMOTOR = 2;
  static const int ROLE_CAPTADOR = 3;
  static const int ROLE_RRHH = 4;

  // Getters
  bool get isAuthenticated => _isAuthenticated.value;
  UserModel? get currentUser => _currentUser.value;

  // Exponer Rx para reactividad
  RxBool get rxIsAuthenticated => _isAuthenticated;
  Rx<UserModel?> get rxCurrentUser => _currentUser;

  String get userRole {
    if (_currentUser.value == null) return '';

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

  // Métodos de verificación de roles
  bool hasRole(int roleId) {
    return _currentUser.value?.roleId == roleId;
  }

  bool hasAnyRole(List<int> roleIds) {
    if (_currentUser.value == null) return false;
    return roleIds.contains(_currentUser.value!.roleId);
  }

  @override
  void onInit() {
    super.onInit();
    _initializeUserService();
    _loadUserFromStorage();
  }

  void _initializeUserService() {
    try {
      _userService = Get.find<UserService>();
    } catch (e) {
      _userService = Get.put(UserService());
    }
  }

  // Métodos privados
  void _loadUserFromStorage() async {
    try {
      final userData = _box.read(_userKey);
      if (userData != null) {
        final user = UserModel.fromJson(userData);

        // Verificar si el usuario está activo consultando su estado actual
        if (user.id > 0) {
          final currentUserState = await _checkUserStatus(user.id);
          if (currentUserState != 1) {
            // Si el usuario ya no está activo, cerrar sesión
            print('El usuario ha sido desactivado. Cerrando sesión...');
            await logout();
            _showSessionClosedAlert();
            return;
          }
        }

        _currentUser.value = user;
        _isAuthenticated.value = true;
      }
    } catch (e) {
      // Si hay algún error al cargar los datos, cerrar la sesión
      logout();
      print('Error al cargar datos de usuario: $e');
    }
  }

  // Verificar el estado actual del usuario en la base de datos
  Future<int?> _checkUserStatus(int userId) async {
    try {
      final user = await _userService.getUserById(userId);
      return user?.stateId;
    } catch (e) {
      print('Error al verificar estado del usuario: $e');
      return null;
    }
  }

  void _showSessionClosedAlert() {
    Get.snackbar(
      'Sesión cerrada',
      'Tu cuenta ha sido desactivada. Por favor, contacta con soporte.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  // Métodos públicos
  Future<void> login(UserModel user) async {
    try {
      _currentUser.value = user;
      _isAuthenticated.value = true;
      await _box.write(_userKey, user.toMap());
    } catch (e) {
      print('Error al guardar datos de sesión: $e');
      throw Exception('Error al iniciar sesión');
    }
  }

  Future<void> logout() async {
    _isAuthenticated.value = false;
    _currentUser.value = null;
    await _box.remove(_userKey);
  }
}
