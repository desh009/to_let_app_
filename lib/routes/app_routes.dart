// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();

  static const String SPLASH = _Paths.SPLASH;
  static const String HOME = _Paths.HOME;
  static const String DETAILS = _Paths.DETAILS;
  static const String SAVED = _Paths.SAVED;

  // CamelCase aliases
  static const String splash = _Paths.SPLASH;
  static const String home = _Paths.HOME;
  static const String details = _Paths.DETAILS;
  static const String saved = _Paths.SAVED;
}

abstract class _Paths {
  _Paths._();

  static const String SPLASH = '/splash';
  static const String HOME = '/home';
  static const String DETAILS = '/details';
  static const String SAVED = '/saved';
}
