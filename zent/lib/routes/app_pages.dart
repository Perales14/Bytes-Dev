import 'package:get/get.dart';
import '../app/modules/clients/bindings/clients_binding.dart';
import '../app/modules/clients/views/clients_view.dart';
import '../app/modules/projects/views/projects_view.dart';
import '../app/modules/employees/bindings/employees_binding.dart';
import '../app/modules/employees/views/employees_view.dart';
import '../app/modules/home/bindings/home_binding.dart';
import '../app/modules/home/views/home_view.dart';
import '../app/modules/projects/bindings/projects_binding.dart';
import '../app/modules/login/bindings/login_binding.dart';
import '../app/modules/login/views/login_view.dart';
import '../app/modules/providers/bindings/providers_binding.dart';
import '../app/modules/providers/views/providers_view.dart';
import '../app/data/services/session_service.dart';
import 'route_guard.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [
        // Solo permitir acceso si NO está autenticado
        NoAuthRequiredGuard(),
      ],
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [
        // Requiere autenticación (cualquier usuario)
        RouteGuard(),
      ],
    ),
    GetPage(
      name: _Paths.EMPLOYEES,
      page: () => const EmployeesView(),
      binding: EmployeesBinding(),
      middlewares: [
        // Solo administradores y recursos humanos
        RouteGuard(allowedRoles: [
          SessionService.ROLE_ADMIN,
          SessionService.ROLE_RRHH
        ]),
      ],
    ),
    GetPage(
      name: _Paths.CLIENTS,
      page: () => const ClientsView(),
      binding: ClientsBinding(),
      middlewares: [
        // Admin, promotor
        RouteGuard(allowedRoles: [
          SessionService.ROLE_ADMIN,
          SessionService.ROLE_PROMOTOR
        ]),
      ],
    ),
    GetPage(
      name: _Paths.PROVIDERS,
      page: () => const ProvidersView(),
      binding: ProvidersBinding(),
      middlewares: [
        // Solo administradores
        RouteGuard(allowedRoles: [SessionService.ROLE_ADMIN]),
      ],
    ),
    GetPage(
      name: _Paths.PROJECTS,
      page: () => const ProjectsView(),
      binding: ProjectsBinding(),
      middlewares: [
        // Administradores y promotores
        RouteGuard(allowedRoles: [
          SessionService.ROLE_ADMIN,
          SessionService.ROLE_PROMOTOR
        ]),
      ],
    ),
    GetPage(
      name: '/access-denied',
      page: () => const AccessDeniedView(),
    ),
  ];
}
