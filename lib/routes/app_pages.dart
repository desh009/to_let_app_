// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/binder/profile_binder.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/view/profile_view.dart';
import 'package:to_let_app_abandon/screens/masaage/binder/massage_binder.dart';
import 'package:to_let_app_abandon/screens/masaage/controller/massage_controller.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/binder/massage_details_binder.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/view/massage_details_view.dart';
import 'package:to_let_app_abandon/screens/masaage/view/massage_view.dart';
import '../screens/auth/bindings/auth_binding.dart';
import '../screens/auth/views/login_screen.dart';
import '../screens/auth/views/register_screen.dart';
import '../screens/auth/views/verify_otp_screen.dart';
import '../screens/details/bindings/details_binding.dart';
import '../screens/details/views/details_screen.dart';
import '../screens/home/bindings/home_binding.dart';
import '../screens/home/views/home_screen.dart';
import '../screens/post_listing/bindings/post_listing_binding.dart';
import '../screens/post_listing/views/post_listing_screen.dart';
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
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.VERIFY_OTP,
      page: () => const VerifyOtpScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
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
    GetPage(
      name: Routes.MESSAGES,
      page: () => const MessagesScreen(),
      binding: MessagesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.MESSAGES_DETAILS,
      page: () => ChatDetailScreen(message: Get.arguments as MessageTileData),
      binding: ChatBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.POST_LISTING,
      page: () => const PostListingScreen(),
      binding: PostListingBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
