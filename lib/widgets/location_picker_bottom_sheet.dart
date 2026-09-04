import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../screens/home/controllers/home_controller.dart';

class LocationPickerBottomSheet extends StatefulWidget {
  final Function(String selectedLocation, String subArea)? onLocationSelected;

  const LocationPickerBottomSheet({
    super.key,
    this.onLocationSelected,
  });

  static void show(BuildContext context, {Function(String, String)? onSelected}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPickerBottomSheet(
        onLocationSelected: onSelected,
      ),
    );
  }

  @override
  State<LocationPickerBottomSheet> createState() => _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  late final TextEditingController _searchController;
  String _selectedSubArea = 'Sonadanga';
  String _searchQuery = '';

  // Khulna Areas List
  final List<Map<String, dynamic>> _khulnaAreas = const [
    {'area': 'Sonadanga', 'count': 124},
    {'area': 'Khalishpur', 'count': 89},
    {'area': 'Boyra', 'count': 76},
    {'area': 'Nirala', 'count': 65},
    {'area': 'Daulatpur', 'count': 52},
    {'area': 'Moylapota', 'count': 48},
    {'area': 'Shibbari', 'count': 43},
    {'area': 'Gollamari', 'count': 38},
    {'area': 'Rupsha', 'count': 32},
    {'area': 'Tutpara', 'count': 28},
    {'area': 'Fulbarigate', 'count': 22},
    {'area': 'Batiaghata', 'count': 18},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      final loc = homeController.selectedLocation.value;
      if (loc.contains(',')) {
        _selectedSubArea = loc.split(',')[0].trim();
      } else if (loc.isNotEmpty) {
        _selectedSubArea = loc;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAreas {
    if (_searchQuery.isEmpty) return _khulnaAreas;
    return _khulnaAreas
        .where((item) =>
            (item['area'] as String).toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 30),
            blurRadius: 20.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),

          // Drag Handle Pill
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 16.h),

          // Top Header (Fixed to Khulna, Bangladesh)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2523) : const Color(0xFFFDEEEA),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.primary.withAlpha(80),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 20.r,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LOCATION',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Khulna, Bangladesh',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E232A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.unfold_more_rounded,
                      size: 16.r,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Search Area Input Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2926) : const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A),
                ),
                decoration: InputDecoration(
                  hintText: 'Search area in Khulna...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20.r,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Scrollable List of Areas
          Expanded(
            child: _filteredAreas.isEmpty
                ? Center(
                    child: Text(
                      'No areas found matching "$_searchQuery"',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                    itemCount: _filteredAreas.length,
                    itemBuilder: (context, index) {
                      final item = _filteredAreas[index];
                      final areaName = item['area'] as String;
                      final count = item['count'] as int;
                      final isSelected = areaName.toLowerCase() == _selectedSubArea.toLowerCase();

                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSubArea = areaName;
                            });

                            final fullLoc = '$areaName, Khulna';
                            if (widget.onLocationSelected != null) {
                              widget.onLocationSelected!(fullLoc, areaName);
                            } else if (Get.isRegistered<HomeController>()) {
                              Get.find<HomeController>().updateLocation(fullLoc);
                            }

                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? const Color(0xFF352420) : const Color(0xFFFDEEEA))
                                  : (isDark ? AppColors.surfaceDark : Colors.white),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.dividerDark : AppColors.borderSubtle.withAlpha(120)),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Location Pin Circle Icon
                                Container(
                                  width: 36.r,
                                  height: 36.r,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withAlpha(30)
                                        : (isDark ? Colors.white10 : const Color(0xFFF5F3EE)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    size: 20.r,
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? AppColors.textSecondaryDark : const Color(0xFF8A8784)),
                                  ),
                                ),
                                SizedBox(width: 14.w),

                                // Area Name & Subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        areaName,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected
                                              ? (isDark ? Colors.white : const Color(0xFF1E232A))
                                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E232A)),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '$count properties',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : const Color(0xFF8A8784),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Trailing Badge / Checkmark
                                if (isSelected)
                                  Container(
                                    width: 26.r,
                                    height: 26.r,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 16.r,
                                      color: Colors.white,
                                    ),
                                  )
                                else
                                  Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : const Color(0xFF8A8784),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Footer info text
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAF8F5),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.dividerDark : AppColors.borderSubtle,
                ),
              ),
            ),
            child: Text(
              '${_khulnaAreas.length} areas in Khulna • Tap to select',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
