import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../../data/repositories/support_repo.dart';

class MyReportsController extends GetxController {
  final SupportRepo _supportRepo = SupportRepo();

  final RxList<dynamic> reportsList = <dynamic>[].obs;
  final RxList<dynamic> requestsList = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;
      final resReports = await _supportRepo.getMyReports();
      if (resReports.isSuccess && resReports.responseData?['data'] != null) {
        final data = resReports.responseData!['data'];
        if (data is List) {
          reportsList.assignAll(data);
        } else if (data['reports'] != null) {
          reportsList.assignAll(data['reports']);
        }
      }

      final resReqs = await _supportRepo.getMyFeatureRequests();
      if (resReqs.isSuccess && resReqs.responseData?['data'] != null) {
        final data = resReqs.responseData!['data'];
        if (data is List) {
          requestsList.assignAll(data);
        } else if (data['requests'] != null) {
          requestsList.assignAll(data['requests']);
        }
      }
    } catch (e) {
      debugPrint('Error fetching reports/requests: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
