import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNumpad extends StatelessWidget {
  final ValueChanged<String> onDigitTap;
  final VoidCallback onDeleteTap;

  const CustomNumpad({
    super.key,
    required this.onDigitTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final padBg = isDark ? const Color(0xFF1E2228) : const Color(0xFFF6F8FA);
    final keyBg = isDark ? const Color(0xFF2B323D) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E232A);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: padBg,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3'], keyBg, textColor),
          SizedBox(height: 10.h),
          _buildRow(['4', '5', '6'], keyBg, textColor),
          SizedBox(height: 10.h),
          _buildRow(['7', '8', '9'], keyBg, textColor),
          SizedBox(height: 10.h),
          _buildBottomRow(keyBg, textColor),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> digits, Color keyBg, Color textColor) {
    return Row(
      children: digits.map((digit) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: _buildKey(
              child: Text(
                digit,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              onTap: () => onDigitTap(digit),
              keyBg: keyBg,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow(Color keyBg, Color textColor) {
    return Row(
      children: [
        // Dot Key
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Container(
              height: 48.h,
              alignment: Alignment.center,
              child: Text(
                '•',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor.withAlpha(80),
                ),
              ),
            ),
          ),
        ),

        // Zero Key
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: _buildKey(
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              onTap: () => onDigitTap('0'),
              keyBg: keyBg,
            ),
          ),
        ),

        // Backspace Key
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: _buildKey(
              child: Icon(
                Icons.backspace_outlined,
                size: 18.r,
                color: textColor,
              ),
              onTap: onDeleteTap,
              keyBg: keyBg,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKey({
    required Widget child,
    required VoidCallback onTap,
    required Color keyBg,
  }) {
    return Material(
      color: keyBg,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 0.5,
      shadowColor: Colors.black.withAlpha(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
