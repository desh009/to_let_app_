import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../widgets/shimmer_loading.dart';
import '../controller/my_reports_controller.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyReportsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          elevation: 0,
          title: Text(
            'My Reports & Requests',
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
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Problem Reports'),
              Tab(text: 'Feature Requests'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 3,
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: const ShimmerLoading(width: double.infinity, height: 80, borderRadius: 16),
              ),
            );
          }

          return TabBarView(
            children: [
              // Reports Tab
              controller.reportsList.isEmpty
                  ? const Center(child: Text('No problem reports submitted'))
                  : ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      itemCount: controller.reportsList.length,
                      itemBuilder: (context, index) {
                        final r = controller.reportsList[index];
                        return _buildCard(
                          title: r['subject'] ?? 'Report',
                          subtitle: r['description'] ?? '',
                          status: r['status'] ?? 'Pending',
                          isDark: isDark,
                        );
                      },
                    ),

              // Requests Tab
              controller.requestsList.isEmpty
                  ? const Center(child: Text('No feature requests submitted'))
                  : ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      itemCount: controller.requestsList.length,
                      itemBuilder: (context, index) {
                        final req = controller.requestsList[index];
                        return _buildCard(
                          title: req['title'] ?? 'Feature Request',
                          subtitle: req['description'] ?? '',
                          status: req['status'] ?? 'Submitted',
                          isDark: isDark,
                        );
                      },
                    ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String status,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
