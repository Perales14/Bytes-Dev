part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const DOCUMENTS = _Paths.DOCUMENTS;
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const EMPLOYEES = _Paths.EMPLOYEES;
  static const CLIENTS = _Paths.CLIENTS;
  static const PROVIDERS = _Paths.PROVIDERS;
  static const PROJECTS = _Paths.PROJECTS;
  static const LOGIN = _Paths.LOGIN;

  // Submódulos de proyectos
  static const PROJECT_DASHBOARD = _Paths.PROJECT_DASHBOARD;
  static const PROJECT_ACTIVITIES = _Paths.PROJECT_ACTIVITIES;
  static const PROJECT_DOCUMENTS = _Paths.PROJECT_DOCUMENTS;
  static const PROJECT_REPORTS = _Paths.PROJECT_REPORTS;
}

abstract class _Paths {
  _Paths._();
  static const DOCUMENTS = '/documents';
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const EMPLOYEES = '/employees';
  static const CLIENTS = '/clients';
  static const PROVIDERS = '/providers';
  static const PROJECTS = '/projects';
  static const LOGIN = '/login';

  // Submódulos de proyectos
  static const PROJECT_DASHBOARD = '/projects/:id/dashboard';
  static const PROJECT_ACTIVITIES = '/projects/:id/activities';
  static const PROJECT_DOCUMENTS = '/projects/:id/documents';
  static const PROJECT_REPORTS = '/projects/:id/reports';
}
