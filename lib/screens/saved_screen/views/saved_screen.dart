import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/nav/nav_controller.dart';
import '../controllers/saved_controller.dart';


class SavedScreen extends GetView<SavedController> {
  const SavedScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navController = Get.find<NavController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────



            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 4.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.savedListings,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        Obx(() => Text(
                              '${controller.savedItems.length} ${AppStrings.savedSubtitle}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.iconMuted,
                              ),
                            )),
                      ],
                    ),
                  ),


                  // Clear all trash icon

                  
                  Obx(() => controller.savedItems.isNotEmpty

                      ? IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 24.r,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.iconMuted,
                          ),
                          onPressed: () => _confirmClearAll(context),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),

            // ── Filter Chips (horizontal scroll) ─────────────────────
            Obx(() {
              if (controller.savedItems.isEmpty) return const SizedBox.shrink();
              final filters = controller.filterOptions;
              return SizedBox(
                height: 38.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, i) {
                    final f = filters[i];
                    final count = controller.countByCategory(f);
                    return Obx(() {
                      final isSelected = controller.selectedFilter.value == f;
                      return GestureDetector(
                        onTap: () => controller.selectFilter(f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.surfaceLight),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.dividerDark
                                      : AppColors.borderMedium),
                            ),
                          ),
                          child: Text(
                            '$f ($count)',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              );
            }),
            SizedBox(height: 12.h),

            // ── Main List ─────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const LoadingIndicator(
                      message: 'Loading saved listings...');
                }

                if (controller.savedItems.isEmpty) {
                  return _EmptyState(isDark: isDark);
                }

                final items = controller.filteredItems;
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No items in this category',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.iconMuted),
                    ),
                  );
                }



                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _SavedCard(
                      item: item,
                      isDark: isDark,
                      onRemove: () => controller.removeFavorite(item.id),
                      onTap: () => Get.toNamed(Routes.DETAILS, arguments: item),
                      onMessage: () => CustomSnackbar.showInfo(
                        title: AppStrings.message,
                        message: 'Opening chat for ${item.title}...',
                      ),
                      onCall: () => CustomSnackbar.showInfo(
                        title: AppStrings.callOwner,
                        message: 'Calling ${item.contactNumber}...',
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: navController.bottomNavBar,
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r)),
        title: Text('Clear All',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
        content: Text(AppStrings.clearAllConfirm,
            style: TextStyle(fontSize: 13.sp)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAll();
            },
            child: Text('Clear',
                style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ── Saved Property Card ───────────────────────────────────────────────────────

class _SavedCard extends StatelessWidget {
  final ToLetItem item;
  final bool isDark;
  final VoidCallback onRemove;
  final VoidCallback onTap;
  final VoidCallback onMessage;
  final VoidCallback onCall;

  const _SavedCard({
    required this.item,
    required this.isDark,
    required this.onRemove,
    required this.onTap,
    required this.onMessage,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = item.isAvailable;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 18 : 6),
              blurRadius: 12.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top row: image + details + heart ──────────────
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      height: 88.r,
                      width: 88.r,
                      color: isDark
                          ? AppColors.dividerDark
                          : AppColors.borderSubtle,
                      child: Image.network(
                        item.images.isNotEmpty
                            ? item.images.first
                            : 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.apartment,
                          color: Colors.grey,
                          size: 32.r,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price
                        Row(
                          children: [
                            Text(
                              '৳${item.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              '/mo',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.iconMuted,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),

                        // Title
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Location
                        Text(
                          item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.iconMuted,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // Stats: beds • baths • status
                        Row(
                          children: [
                            Text(
                              '${item.bedrooms} Beds',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                            _dot(),
                            Text(
                              '${item.bathrooms} Baths',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                            _dot(),
                            Text(
                              isAvailable
                                  ? AppStrings.available
                                  : AppStrings.pendingVisit,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: isAvailable
                                    ? AppColors.badgeGreenText
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Heart / Remove button
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.error,
                      size: 22.r,
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ────────────────────────────────────────
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
            ),

            // ── Action Buttons: Message | Call Owner ───────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  // Message button (outlined)
                  Expanded(
                    child: GestureDetector(
                      onTap: onMessage,
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.borderMedium,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 16.r,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              AppStrings.message,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Call Owner button (terracotta filled)
                  Expanded(
                    child: GestureDetector(
                      onTap: onCall,
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(60),
                              blurRadius: 8.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone_outlined,
                                color: Colors.white, size: 16.r),
                            SizedBox(width: 6.w),
                            Text(
                              AppStrings.callOwner,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Text('•',
            style: TextStyle(fontSize: 10.sp, color: AppColors.borderMedium)),
      );
}

// ── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 64.r,
            color: isDark ? AppColors.textSecondaryDark : AppColors.borderMedium,
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.noSavedProperties,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.noSavedSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.iconMuted,
            ),
          ),
        ],
      ),
    );
  }
}