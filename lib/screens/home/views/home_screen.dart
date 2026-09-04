// screens/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/featured_property_card.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/floating_action_pills.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/home_header.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/home_search_bar.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/limited_offer_banner.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/quick_search_categories.dart';
import 'package:to_let_app_abandon/screens/home/LayOut/items/Items/recommended_property_card.dart';
import 'package:to_let_app_abandon/widgets/nav/nav_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
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
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
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
                    const HomeHeader(),

                    const HomeSearchBar(),

                    SizedBox(height: 4.h),

                    // 1. Horizontal Category Pills Row
                    const QuickSearchCategories(),

                    // 2. Limited Offer Banner Card
                    const LimitedOfferBanner(),

                    SizedBox(height: 4.h),

                    // 3. Near You / Featured Properties Section Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Near you - Khulna to Shiromoni',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : const Color(0xFF1E232A),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.selectCategory('');
                              Get.toNamed(Routes.FILTER_RESULTS);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'See all'.tr,
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 15.r,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Featured Horizontal Carousel
                    Obx(() {
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: 180.h,
                          child: LoadingIndicator(
                            message: 'loading_featured'.tr,
                          ),
                        );
                      }

                      if (controller.featuredProperties.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Center(
                            child: Text(
                              'no_featured_properties'.tr,
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
                        height: 220.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 20.w, right: 6.w),
                          itemCount: controller.featuredProperties.length,
                          itemBuilder: (context, index) {
                            final item = controller.featuredProperties[index];
                            return FeaturedPropertyCard(
                              item: item,
                              onTap: () {
                                navController.toDetails(item);
                              },
                            );
                          },
                        ),
                      );
                    }),

                    SizedBox(height: 20.h),

                    // 4. Recommended for you Section Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'recommended_for_you'.tr,
                            style: TextStyle(
                              fontSize: 17.5.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : const Color(0xFF1E232A),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF352420)
                                  : const Color(0xFFFDF0ED),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Text(
                              'BASED ON FILTER',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Recommended Vertical List
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: LoadingIndicator(
                            message: 'loading_recommendations'.tr,
                          ),
                        );
                      }

                      if (controller.recommendedProperties.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Center(
                            child: Text(
                              'no_properties_found'.tr,
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
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Floating Dual Action Pills (Post Listing & Map View)
            Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: FloatingActionPills(
                onPostListing: () {
                  navController.toPostListing();
                },
                onMapView: () {
                  CustomSnackbar.showInfo(
                    title: 'map_view'.tr,
                    message: 'interactive_map'.tr,
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