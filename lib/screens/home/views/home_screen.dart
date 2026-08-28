// screens/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/featured_property_card.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/floating_action_pills.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/home_header.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/home_search_bar.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/quick_search_categories.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/recommended_property_card.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/loading_indicator.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navController = Get.find<NavController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main Scrollable Content
            RefreshIndicator(
              onRefresh: controller.loadProperties,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 90.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header (Greeting & Notification)
                    const HomeHeader(),

                    const HomeSearchBar(),

                    const QuickSearchCategories(),

                    SizedBox(height: 8.h),

                    // 4. Featured Properties Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Featured properties',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF1E232A),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.selectCategory('');
                            },
                            child: Text(
                              'View all',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Featured Horizontal Carousel
                    Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: 180.h,
                          child: const LoadingIndicator(
                            message: 'Loading featured listings...',
                          ),
                        );
                      }

                      if (controller.featuredProperties.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Center(
                            child: Text(
                              'No featured properties in this category',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 310.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 20.w, right: 4.w),
                          itemCount: controller.featuredProperties.length,
                          itemBuilder: (context, index) {
                            final item = controller.featuredProperties[index];
                            return FeaturedPropertyCard(
                                item: item,
                                onTap: () {
                                  // ✅ NavController ব্যবহার করে Navigate
                                  navController.toDetails(item);
                                  // অথবা সরাসরি
                                  // Get.toNamed(Routes.DETAILS, arguments: item);
                                },
                              
                            );
                          },
                        ),
                      );
                    }),

                    SizedBox(height: 16.h),

                    // 5. Recommended for you Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Recommended for you',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF1E232A),
                              ),
                            ),
                          ),
                          Container(
                            height: 36.r,
                            width: 36.r,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.borderSubtle,
                              ),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 18.r,
                              color: const Color(0xFF1E232A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Recommended Vertical List
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: LoadingIndicator(
                            message: 'Loading recommendations...',
                          ),
                        );
                      }

                      if (controller.recommendedProperties.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Center(
                            child: Text(
                              'No properties found',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: controller.recommendedProperties.length,
                        itemBuilder: (context, index) {
                          final item = controller.recommendedProperties[index];
                          return RecommendedPropertyCard(
                            item: item,
                            onTap: () {
                              navController.toDetails(item);
                              // অথবা সরাসরি
                              // Get.toNamed(Routes.DETAILS, arguments: item);
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            // 6. Floating Dual Action Pills (Post Listing & Map View)
            Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: FloatingActionPills(
                onPostListing: () {
                  // ✅ NavController ব্যবহার করে Navigate
                  // navController.toPostListing();
                  // অথবা Snackbar দেখান
                  CustomSnackbar.showInfo(
                    title: 'Post a listing',
                    message: 'Redirecting to property submission form...',
                  );
                },
                onMapView: () {
                  // ✅ NavController ব্যবহার করে Navigate
                  // navController.toMapView();
                  // অথবা Snackbar দেখান
                  CustomSnackbar.showInfo(
                    title: 'Map View',
                    message: 'Interactive Dhaka Map will open here...',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: navController.bottomNavBar,
    );
  }
}