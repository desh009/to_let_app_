import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/home_controller.dart';

class StorageDemoDialog extends StatelessWidget {
  const StorageDemoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final nameInputController = TextEditingController(text: controller.savedUserName.value);
    final phoneInputController = TextEditingController(text: controller.savedUserPhone.value);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: Colors.blue, size: 28.r),
                SizedBox(width: 10.w),
                Text(
                  'User Preferences',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Update your profile in local SharedPreferences:',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey),
            ),
            SizedBox(height: 18.h),
            CustomTextField(
              label: 'User Name',
              hintText: 'Enter your name',
              prefixIcon: Icons.person_outline,
              controller: nameInputController,
            ),
            SizedBox(height: 14.h),
            CustomTextField(
              label: 'Phone Number',
              hintText: 'Enter phone number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              controller: phoneInputController,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    isOutlined: true,
                    height: 46.h,
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Save',
                    height: 46.h,
                    onPressed: () {
                      controller.updateUserProfile(
                        nameInputController.text.trim(),
                        phoneInputController.text.trim(),
                      );
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
