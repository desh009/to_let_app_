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
  static const String POST_LISTING = _Paths.POST_LISTING;
  static const String LOGIN = _Paths.LOGIN;
  static const String REGISTER = _Paths.REGISTER;
  static const String VERIFY_OTP = _Paths.VERIFY_OTP;

  // CamelCase aliases
  static const String splash = _Paths.SPLASH;
  static const String home = _Paths.HOME;
  static const String details = _Paths.DETAILS;
  static const String saved = _Paths.SAVED;
  static const String messages = _Paths.MESSAGES;
  static const String profile = _Paths.PROFILE;
  static const String messages_details = _Paths.MESSAGES_DETAILS;
  static const String post_listing = _Paths.POST_LISTING;
  static const String login = _Paths.LOGIN;
  static const String register = _Paths.REGISTER;
  static const String verify_otp = _Paths.VERIFY_OTP;
}

abstract class _Paths {
  _Paths._();

  static const String SPLASH = '/splash';
  static const String HOME = '/home';
  static const String DETAILS = '/details';
  static const String SAVED = '/saved';
  static const String MESSAGES = '/messages';
  static const String PROFILE = '/profile';
  static const String MESSAGES_DETAILS = '/messages-details';
  static const String POST_LISTING = '/post-listing';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String VERIFY_OTP = '/verify-otp';
}
