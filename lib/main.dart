import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/services/fcm_service.dart';
import 'package:to_let_app_abandon/app/app_translation/app_translation.dart';
import 'package:to_let_app_abandon/widgets/custom_floating_action button/custom_floating_action_button.dart';
import 'core/bindings/initial_binding.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/storage_keys.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'widgets/custom_snackbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (এটা লাগবেই, তুলনামূলক দ্রুত)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register top-level background messaging handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize SharedPreferences via GetX Service — UI বানানোর আগে দরকার (theme/lang জানতে)
  final storageService = await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

  // Check saved theme preference
  final isDarkMode = storageService.getBool(StorageKeys.isDarkMode) ?? false;

  // Check saved language preference
  final savedLang = storageService.getString(StorageKeys.language) ?? 'en';

  // ✅ আগে App রান করে UI দেখান — এতে app সাথে সাথে খুলবে
  runApp(MyApp(isDarkMode: isDarkMode, savedLang: savedLang));

  // ✅ FCM init এখন background এ চলবে (permission popup + token fetch),
  // UI render হওয়া block করবে না
  Get.putAsync<FcmService>(
    () => FcmService().init(),
    permanent: true,
  );
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
          // ★ পুরো অ্যাপের উপরে global overlay হিসেবে ShutterFab বসানো হলো
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,

                // ★ Global Voice Assistant Shutter FAB (এখন placeholder)
                ShutterFab(
                  icon: Icons.mic_none_rounded,
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    CustomSnackbar.showInfo(
                      title: 'Voice Assistant',
                      message: 'Voice feature coming soon...',
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}