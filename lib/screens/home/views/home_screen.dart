import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/loading_indicator.dart';
import '../controllers/home_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/featured_property_card.dart';
import '../widgets/floating_action_pills.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/quick_search_categories.dart';
import '../widgets/recommended_property_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                padding: EdgeInsets.only(bottom: 110.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header (Greeting & Notification)
                    const HomeHeader(),

                    // 2. Search Bar & Filter Action
                    const HomeSearchBar(),

                    // 3. Quick Search Categories
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
                                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
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
                          child: const LoadingIndicator(message: 'Loading featured listings...'),
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
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                            return Obx(
                              () => FeaturedPropertyCard(
                                item: item,
                                isFavorite: controller.isFavorite(item.id),
                                onTap: () {
                                  Get.toNamed(Routes.DETAILS, arguments: item);
                                },
                                onFavoriteToggle: () {
                                  controller.toggleFavorite(item.id);
                                },
                              ),
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
                                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                              ),
                            ),
                          ),
                          Container(
                            height: 36.r,
                            width: 36.r,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
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
                          child: LoadingIndicator(message: 'Loading recommendations...'),
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
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                          return Obx(
                            () => RecommendedPropertyCard(
                              item: item,
                              isFavorite: controller.isFavorite(item.id),
                              onTap: () {
                                Get.toNamed(Routes.DETAILS, arguments: item);
                              },
                              onFavoriteToggle: () {
                                controller.toggleFavorite(item.id);
                              },
                            ),
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
                  CustomSnackbar.showInfo(
                    title: 'Post a listing',
                    message: 'Redirecting to property submission form...',
                  );
                },
                onMapView: () {
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

      // 7. Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.currentNavIndex.value,
          onTap: controller.changeNavTab,
        ),
      ),
    );
  }
}
