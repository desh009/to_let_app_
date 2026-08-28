import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/widgets/custom_floating_action%20button/custom_floating_action_button.dart';
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

  // Initialize SharedPreferences via GetX Service
  final storageService = await Get.putAsync<StorageService>(
    () => StorageService().init(),
    permanent: true,
  );

  // Check saved theme preference
  final isDarkMode = storageService.getBool(StorageKeys.isDarkMode) ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, this.isDarkMode = false});

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