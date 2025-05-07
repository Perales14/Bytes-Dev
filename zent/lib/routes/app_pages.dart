import 'package:get/get.dart';
import '../app/data/models/project_model.dart';
import '../app/modules/clients/bindings/clients_binding.dart';
import '../app/modules/clients/views/clients_view.dart';
import '../app/modules/projects/submodules/activities/bindings/project_activities_biding.dart';
import '../app/modules/projects/submodules/dashboard/bindings/project_dashboard_biding.dart';
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
import '../app/modules/splash/bindings/splash_binding.dart';
import '../app/modules/splash/views/splash_view.dart';
import '../app/data/services/session_service.dart';
import '../app/modules/projects/submodules/dashboard/views/project_dashboard_view.dart';
import '../app/modules/projects/submodules/activities/views/project_activities_view.dart';
import '../app/modules/projects/submodules/documents/bindings/project_documents_binding.dart';
import '../app/modules/projects/submodules/documents/views/project_documents_view.dart';
import '../app/modules/projects/submodules/reports/bindings/project_reports_binding.dart';
import '../app/modules/projects/submodules/reports/views/project_reports_view.dart';
import '../app/modules/projects/controllers/projects_controller.dart';
import 'route_guard.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Cambiar la ruta inicial a SPLASH
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Ruta de Splash (nueva)
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
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

    // Submódulos de proyectos
    GetPage(
      name: _Paths.PROJECT_DASHBOARD,
      page: () => ProjectDashboardView(),
      binding: ProjectDashboardBinding(),
      middlewares: [
        RouteGuard(allowedRoles: [
          SessionService.ROLE_ADMIN,
          SessionService.ROLE_PROMOTOR
        ]),
      ],
    ),
    GetPage(
      name: _Paths.PROJECT_ACTIVITIES,
      page: () => ProjectActivitiesView(),
      binding: ProjectActivitiesBinding(),
      middlewares: [
        RouteGuard(allowedRoles: [
          SessionService.ROLE_ADMIN,
          SessionService.ROLE_PROMOTOR
        ]),
      ],
    ),
    GetPage(
      name: _Paths.PROJECT_DOCUMENTS,
      page: () => ProjectDocumentsView(),
      binding: ProjectDocumentsBinding(),
      middlewares: [
        RouteGuard(allowedRoles: [
          SessionService.ROLE_ADMIN,
          SessionService.ROLE_PROMOTOR
        ]),
      ],
    ),
    GetPage(
      name: _Paths.PROJECT_REPORTS,
      page: () => ProjectReportsView(),
      binding: ProjectReportsBinding(),
      middlewares: [
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
