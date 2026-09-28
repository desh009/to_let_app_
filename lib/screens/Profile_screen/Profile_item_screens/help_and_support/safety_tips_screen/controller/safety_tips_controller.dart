import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../../data/repositories/support_repo.dart';

class SafetyTipsController extends GetxController {
  final SupportRepo _supportRepo = SupportRepo();

  final RxList<dynamic> safetyTips = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSafetyTips();
  }

  Future<void> fetchSafetyTips() async {
    try {
      isLoading.value = true;
      final response = await _supportRepo.getSafetyTips();
      if (response.isSuccess && response.responseData?['data'] != null) {
        final data = response.responseData!['data'];
        if (data is List) {
          safetyTips.assignAll(data);
        } else if (data['tips'] != null) {
          safetyTips.assignAll(data['tips']);
        }
      }
    } catch (e) {
      debugPrint('Error fetching safety tips: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
