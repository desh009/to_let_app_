import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_let_app_abandon/core/constants/app_strings.dart';
import 'package:to_let_app_abandon/core/services/storage_service.dart';
import 'package:to_let_app_abandon/main.dart';

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await Get.putAsync<StorageService>(
      () => StorageService().init(),
      permanent: true,
    );
  });

  testWidgets('App initializes, shows splash, and navigates to home', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375 * 2, 812 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MyApp());

    // Initially on Splash screen
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.splashTagline), findsOneWidget);

    // Fast-forward past the 2-second splash timer & transitions
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify Home screen is now displayed with mock UI elements
    expect(find.text('Find your next place'), findsOneWidget);
    expect(find.text('Quick search'), findsOneWidget);
    expect(find.text('Featured properties'), findsOneWidget);
  });
}
