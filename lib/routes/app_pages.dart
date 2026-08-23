// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import '../screens/details/bindings/details_binding.dart';
import '../screens/details/views/details_screen.dart';
import '../screens/home/bindings/home_binding.dart';
import '../screens/home/views/home_screen.dart';
import '../screens/saved_screen/bindings/saved_binding.dart';
import '../screens/saved_screen/views/saved_screen.dart';
import '../screens/splash/bindings/splash_binding.dart';
import '../screens/splash/views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String INITIAL = Routes.SPLASH;
  static const String initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.DETAILS,
      page: () => const DetailsScreen(),
      binding: DetailsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.SAVED,
      page: () => const SavedScreen(),
      binding: SavedBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
