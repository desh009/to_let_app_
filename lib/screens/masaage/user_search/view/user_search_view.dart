import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/shimmer_widgets.dart';
import '../controller/user_search_controller.dart';

class UserSearchScreen extends GetView<UserSearchController> {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8F5),
        elevation: 0,
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'Search users by name...',
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: controller.searchUsers,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return UserSearchShimmer(isDark: isDark);
        }

        if (controller.searchResults.isEmpty) {
          return Center(
            child: Text(
              controller.searchController.text.length < 2
                  ? 'Type at least 2 characters to search'
                  : 'No users found',
              style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final user = controller.searchResults[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${user['name']}'),
              ),
              title: Text(
                user['name'] ?? 'Unknown',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user['email'] ?? '',
                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
              ),
              onTap: () => controller.startConversation(user),
            );
          },
        );
      }),
    );
  }
}
