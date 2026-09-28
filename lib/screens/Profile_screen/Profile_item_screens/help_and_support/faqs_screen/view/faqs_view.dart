import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../widgets/shimmer_loading.dart';
import '../controller/faqs_controller.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaqsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        title: Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Category filter
          SizedBox(height: 10.h),
  Obx(() {
  if (controller.categories.isEmpty) {
    return const SizedBox.shrink();
  }

  return SizedBox(
    height: 40.h,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        _buildChip(controller, '', 'All', isDark),
        ...controller.categories.map(
          (cat) => _buildChip(controller, cat, cat, isDark),
        ),
      ],
    ),
  );
}),
          SizedBox(height: 10.h),
          
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: 5,
                  itemBuilder: (_, __) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: const ShimmerLoading(width: double.infinity, height: 70, borderRadius: 12),
                  ),
                );
              }

              if (controller.faqsList.isEmpty) {
                return const Center(child: Text('No FAQs found'));
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: controller.faqsList.length,
                itemBuilder: (context, index) {
                  final faq = controller.faqsList[index];
                  // Handle both grouped category object or flat list
                  final question = faq['question'] ?? '';
                  final answer = faq['answer'] ?? '';

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                      ),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        question,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(FaqsController controller, String val, String label, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == val;
      return Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          selectedColor: AppColors.primary,
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontSize: 12.sp,
          ),
          onSelected: (_) => controller.filterByCategory(val),
        ),
      );
    });
  }
}
