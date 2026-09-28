import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../../data/repositories/support_repo.dart';

class FaqsController extends GetxController {
  final SupportRepo _supportRepo = SupportRepo();

  final RxList<dynamic> faqsList = <dynamic>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs({String? category}) async {
    try {
      isLoading.value = true;
      final response = await _supportRepo.getFaqs(category: category);
      if (response.isSuccess && response.responseData?['data'] != null) {
        final data = response.responseData!['data'];
        if (data['faqs'] != null) {
          faqsList.assignAll(data['faqs']);
        }
        if (data['categories'] != null) {
          categories.assignAll(List<String>.from(data['categories']));
        }
      }
    } catch (e) {
      debugPrint('Error fetching FAQs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    fetchFaqs(category: cat.isEmpty ? null : cat);
  }
}
