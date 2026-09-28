import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';

class SupportRepo {
  final NetworkService _networkService = Get.find<NetworkService>();


  

  /// Get contact info (phone, email, whatsapp, office)
  Future<NetworkResponse> getContactInfo() async {
    return await _networkService.get(Urls.supportContactInfo);
  }



  /// Get FAQs (optional category filter)
  Future<NetworkResponse> getFaqs({String? category}) async {
    final query = category != null && category.isNotEmpty ? {'category': category} : null;
    return await _networkService.get(Urls.supportFaqs, queryParams: query);
  }


  /// Get safety tips
  Future<NetworkResponse> getSafetyTips() async {
    return await _networkService.get(Urls.supportSafetyTips);
  }



  /// Report a problem
  Future<NetworkResponse> reportProblem({
    required String subject,
    required String description,
    String category = 'other',
    String priority = 'medium',
    String? email,
    String? phone,
    List<String>? attachments,
  }) async {
    return await _networkService.post(
      Urls.supportReportProblem,
      body: {
        'subject': subject,
        'description': description,
        'category': category,
        'priority': priority,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (attachments != null) 'attachments': attachments,
      },
    );
  }

  /// Request a feature
  Future<NetworkResponse> requestFeature({
    required String title,
    required String description,
    String category = 'other',
    String priority = 'nice-to-have',
  }) async {
    return await _networkService.post(
      Urls.supportRequestFeature,
      body: {
        'title': title,
        'description': description,
        'category': category,
        'priority': priority,
      },
    );
  }

  /// Get Terms of Service
  Future<NetworkResponse> getTerms() async {
    return await _networkService.get(Urls.supportTerms);
  }

  /// Get Privacy Policy
  Future<NetworkResponse> getPrivacy() async {
    return await _networkService.get(Urls.supportPrivacy);
  }

  /// Get User's support reports
  Future<NetworkResponse> getMyReports() async {
    return await _networkService.get(Urls.supportMyReports);
  }

  /// Get User's feature requests
  Future<NetworkResponse> getMyFeatureRequests() async {
    return await _networkService.get(Urls.supportMyFeatureRequests);
  }
}
