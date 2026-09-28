class Urls {
  static const String baseUrl = 'https://to-let-api-main.onrender.com';
  static const String registerSendOtp = "$baseUrl/api/auth/register/send-otp";
  static const String registerVerifyOtp =
      "$baseUrl/api/auth/register/verify-otp";
  static const String registerResendOtp =
      "$baseUrl/api/auth/register/resend-otp";
  static const String login = "$baseUrl/api/auth/login";
  static const String forgotPasswordSendOtp =
      "$baseUrl/api/auth/forgot-password/send-otp";
  static const String forgotPasswordVerifyOtp =
      "$baseUrl/api/auth/forgot-password/verify-otp";
  static const String forgotPasswordReset =
      "$baseUrl/api/auth/forgot-password/reset-password";
  static const String resetPassword = "$baseUrl/api/auth/reset-password";
  static const String logout = "$baseUrl/api/auth/logout";
  static const String me = "$baseUrl/api/auth/me";
  static const String refreshToken = "$baseUrl/api/auth/refresh";

  // 🟢 Listings related
  static const String homeListings = "$baseUrl/api/listings/home";
  static const String allListings = "$baseUrl/api/listings";
  static const String filterOptions = "$baseUrl/api/listings/filters/options";

  // 🟢 User related
  static const String profile = "$baseUrl/api/user/profile";
  static const String updateProfile = "$baseUrl/api/user/profile";
  static const String uploadAvatar = "$baseUrl/api/user/avatar";
  static const String changePassword = "$baseUrl/api/user/change-password";

  // 🟢 Property / Listings related
  static const String myListings = "$baseUrl/api/listings/user/my-listings";
  static String listingById(String id) => "$baseUrl/api/listings/$id";

  // 🟢 Favorites related
  static const String favorites = "$baseUrl/api/favorites";
  static String favoriteById(String id) => "$baseUrl/api/favorites/$id";
  static String checkFavorite(String id) => "$baseUrl/api/favorites/check/$id";

  // 🟢 Notifications related
  static const String notifications = "$baseUrl/api/notifications";
  static String notificationRead(String id) =>
      "$baseUrl/api/notifications/$id/read";
  static const String notificationsReadAll =
      "$baseUrl/api/notifications/read-all";

  // 🟢 Messages / Chat related
  static const String conversations = "$baseUrl/api/messages/conversations";
  static const String sendMessage = "$baseUrl/api/messages/send";
  static String messagesByConversation(String conversationId) =>
      "$baseUrl/api/messages/conversations/$conversationId/messages";
  static const String markMessagesRead = "$baseUrl/api/messages/mark-as-read";
  static const String searchUsers = "$baseUrl/api/messages/users/search";

  // 🟢 Upload related
  static const String uploadImages = "$baseUrl/api/upload/images";

  // 🟢 Support & Security related
  static const String supportContactInfo = "$baseUrl/api/support/contact-info";
  static const String supportFaqs = "$baseUrl/api/support/faqs";
  static const String supportSafetyTips = "$baseUrl/api/support/safety-tips";
  static const String supportReportProblem = "$baseUrl/api/support/report-problem";
  static const String supportRequestFeature = "$baseUrl/api/support/request-feature";
  static const String supportTerms = "$baseUrl/api/support/terms";
  static const String supportPrivacy = "$baseUrl/api/support/privacy";
  static const String supportMyReports = "$baseUrl/api/support/my-reports";
  static const String supportMyFeatureRequests = "$baseUrl/api/support/my-feature-requests";
}
