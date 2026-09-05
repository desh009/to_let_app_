import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/services/fcm_service.dart';
import 'core/controllers/gemini_voice_controller.dart';
import 'package:to_let_app_abandon/app/app_translation/app_translation.dart';
import 'package:to_let_app_abandon/widgets/custom_floating_action button/custom_floating_action_button.dart';
import 'core/bindings/initial_binding.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/storage_keys.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';



import 'widgets/custom_snackbar.dart';

final ValueNotifier<String> currentRouteNotifier = ValueNotifier<String>('');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  final storageService = await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );


  final isDarkMode = storageService.getBool(StorageKeys.isDarkMode) ?? false;


  final savedLang = storageService.getString(StorageKeys.language) ?? 'en';

  runApp(MyApp(isDarkMode: isDarkMode, savedLang: savedLang));


  Get.putAsync<FcmService>(
    () => FcmService().init(),
    permanent: true,
  );

  // Register Gemini Voice Controller globally
  Get.put(GeminiVoiceController(), permanent: true);
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final String savedLang;

  const MyApp({
    super.key,
    this.isDarkMode = false,
    this.savedLang = 'en',
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          locale: Locale(savedLang),
          fallbackLocale: const Locale('en'),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          navigatorObservers: [
            GetObserver((routing) {
              if (routing?.current != null && routing!.current.isNotEmpty) {
                currentRouteNotifier.value = routing.current;
              }
            }),
          ],
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,


                const GlobalFloatingFab(),
              ],
            );
          },
        );
      },
    );
  }
}

class GlobalFloatingFab extends StatelessWidget {
  const GlobalFloatingFab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentRouteNotifier,
      builder: (context, currentRoute, child) {
        final activeRoute = currentRoute.isEmpty ? Get.currentRoute : currentRoute;
        final hideOnRoutes = [
          Routes.LOGIN,
          Routes.REGISTER,
          Routes.VERIFY_OTP,
          Routes.FORGOT_PASSWORD,
          Routes.SPLASH,
          Routes.TWO_FACTOR_AUTH,
          '/login',
          '/register',
          '/verify-otp',
          '/forgot-password',
          '/splash',
          '/two-factor-auth',
        ];

        if (hideOnRoutes.contains(activeRoute)) {
          return const SizedBox.shrink();
        }

        // Press‑and‑hold voice button (no bottom sheet)
        return GestureDetector(
          onLongPressStart: (_) => GeminiVoiceController.to.startListening(),
          onLongPressEnd: (_) => GeminiVoiceController.to.stopListening(),
          child: Obx(() {
            final isListening = GeminiVoiceController.to.isListening.value;
            return FloatingActionButton(
              backgroundColor: isListening ? Colors.redAccent : AppColors.primary,
              child: Icon(
                isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                CustomSnackbar.showInfo(
                  title: 'Gemini Voice Search',
                  message: 'Press & hold the mic button to speak.',
                );
              },
            );
          }),
        );
      },
    );
  }
}