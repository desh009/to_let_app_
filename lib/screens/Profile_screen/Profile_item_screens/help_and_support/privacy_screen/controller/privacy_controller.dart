import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../../data/repositories/support_repo.dart';

class PrivacyController extends GetxController {
  final SupportRepo _supportRepo = SupportRepo();

  final RxList<dynamic> privacyList = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacy();
  }

  Future<void> fetchPrivacy() async {
    try {
      isLoading.value = true;
      final response = await _supportRepo.getPrivacy();
      if (response.isSuccess && response.responseData?['data'] != null) {
        final data = response.responseData!['data'];
        if (data is List) {
          privacyList.assignAll(data);
        } else if (data['sections'] != null) {
          privacyList.assignAll(data['sections']);
        }
      }
    } catch (e) {
      debugPrint('Error fetching privacy policy: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
