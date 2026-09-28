import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../../data/repositories/support_repo.dart';

class TermsController extends GetxController {
  final SupportRepo _supportRepo = SupportRepo();

  final RxList<dynamic> termsList = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    try {
      isLoading.value = true;
      final response = await _supportRepo.getTerms();
      if (response.isSuccess && response.responseData?['data'] != null) {
        final data = response.responseData!['data'];
        if (data is List) {
          termsList.assignAll(data);
        } else if (data['sections'] != null) {
          termsList.assignAll(data['sections']);
        }
      }
    } catch (e) {
      debugPrint('Error fetching terms: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
