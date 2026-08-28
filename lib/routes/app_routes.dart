// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();

  static const String SPLASH = _Paths.SPLASH;
  static const String HOME = _Paths.HOME;
  static const String DETAILS = _Paths.DETAILS;
  static const String SAVED = _Paths.SAVED;
  static const String MESSAGES = _Paths.MESSAGES;
  static const String PROFILE = _Paths.PROFILE;
    static const String MESSAGES_DETAILS = _Paths.MESSAGES_DETAILS;


  // CamelCase aliases
  static const String splash = _Paths.SPLASH;
  static const String home = _Paths.HOME;
  static const String details = _Paths.DETAILS;
  static const String saved = _Paths.SAVED;
  static const String messages = _Paths.MESSAGES;
  static const String profile = _Paths.PROFILE;
    static const String messages_details = _Paths.MESSAGES_DETAILS;

}

abstract class _Paths {
  _Paths._();

  static const String SPLASH = '/splash';
  static const String HOME = '/home';
  static const String DETAILS = '/details';
  static const String SAVED = '/saved';
  static const String MESSAGES = '/messages';
  static const String PROFILE = '/profile';
    static const String MESSAGES_DETAILS= '/messages-details';

}