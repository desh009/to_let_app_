// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:to_let_app_abandon/app/two_factor_contoller_addtion/screen/two_factor_auth_screen.dart';
// import 'package:to_let_app_abandon/screens/Filter_screen/controller/filter_controller.dart';
// import 'package:to_let_app_abandon/screens/Filter_screen/view/filter_view.dart';
// import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/edit_profile/edit_profile_controller.dart';
// import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/edit_profile/screen.dart';
import '../screens/filter/views/filter_results_screen.dart';
import '../screens/notifications/views/notifications_screen.dart';
import '../screens/notifications/controllers/notifications_controller.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/call_support/binder/call_support_binder.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/call_support/view/call_support_view.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/email_support/binder/email_support-binder.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/help_and_support/email_support/view/email_support_view.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/privacy_and_policy/binder/privacy_policy_binding.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/privacy_and_policy/view/privacy_and_policy_view.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/report_problem_screen/binder/report_problem_binder.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/report_problem_screen/view/report_problem_view.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/terms_and_services_screen/binder/terms_and_controller_binder.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/Profile_item_screens/terms_and_services_screen/view/terms_and_services_view.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/binder/profile_binder.dart';
import 'package:to_let_app_abandon/screens/Profile_screen/view/profile_view.dart';
import 'package:to_let_app_abandon/screens/auth/controllers/auth_controller.dart';
import 'package:to_let_app_abandon/screens/masaage/binder/massage_binder.dart';
import 'package:to_let_app_abandon/screens/masaage/controller/massage_controller.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/binder/massage_details_binder.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/view/massage_details_view.dart';
import 'package:to_let_app_abandon/screens/masaage/view/massage_view.dart';
import 'package:to_let_app_abandon/screens/auth/views/forgot_password_screen.dart';
// import 'package:to_let_app_abandon/screens/notification_screen/controller/notification_controlelr.dart';
// import 'package:to_let_app_abandon/screens/notification_screen/view/notification_view.dart';
import '../screens/auth/bindings/auth_binding.dart';
import '../screens/auth/views/login_screen.dart';
import '../screens/auth/views/register_screen.dart';
import '../screens/auth/views/verify_otp_screen.dart';
import '../screens/details/bindings/details_binding.dart';
import '../screens/details/views/details_screen.dart';
import '../screens/filter/bindings/filter_binding.dart';
import '../screens/filter/views/filter_screen.dart';
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
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
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
    GetPage(
      name: Routes.CALL_SUPPORT,
      page: () => const CallUsScreen(),
      binding: CallUsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.EMAIL_SUPPORT,
      page: () => const EmailSupportScreen(),
      binding: EmailSupportBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.REPORT_A_PROBLEM,
      page: () => const ReportProblemScreen(),
      binding: ReportProblemBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.TERMS_AND_SERVICES,
      page: () => const TermsOfServiceScreen(),
      binding: TermsOfServiceBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PRIVACY_AND_POLICY,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsScreen(),
      binding: BindingsBuilder(() {
        NotificationsController.to;
      }),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.TWO_FACTOR_AUTH,
      page: () => const TwoFactorAuthScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AuthController>()) {
          Get.put(AuthController());
        }
      }),
    ),

    // GetPage(
    //   name: '/edit-profile',
    //   page: () => const EditProfileScreen(),
    //   binding: BindingsBuilder(() {
    //     Get.put(EditProfileController());
    //   }),
    // ),


    GetPage(
      name: Routes.FILTER,
      page: () => const FilterScreen(),
      binding: FilterBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.FILTER_RESULTS,
      page: () => const FilterResultsScreen(),
      binding: FilterBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
