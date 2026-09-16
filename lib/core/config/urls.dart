class Urls {
  static const String baseUrl = "http://10.0.2.2:3000"; // Android Emulator

  // 🟢 Auth related
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
  static const String resetPassword = "$baseUrl/api/auth/reset-password";
  static const String logout = "$baseUrl/api/auth/logout";

  // 🟢 Listings related
  static const String homeListings = "$baseUrl/api/listings/home";
  static const String allListings = "$baseUrl/api/listings";
  static const String filterOptions = "$baseUrl/api/listings/filters/options";

  // // 🟢 User related
  // static const String profile = "$baseUrl/api/user/profile";
  // static const String updateProfile = "$baseUrl/api/user/update-profile";

  // // 🟢 Property related
  // static const String properties = "$baseUrl/api/properties";
  // static String propertyById(String id) => "$baseUrl/api/properties/$id";
  // static const String createProperty = "$baseUrl/api/properties/create";
  // static String updateProperty(String id) => "$baseUrl/api/properties/update/$id";
  // static String deleteProperty(String id) => "$baseUrl/api/properties/delete/$id";

  // // 🟢 Favorites related
  // static const String favorites = "$baseUrl/api/favorites";
  // static const String addFavorite = "$baseUrl/api/favorites/add";
  // static String removeFavorite(String id) => "$baseUrl/api/favorites/remove/$id";

  // // 🟢 Messages related
  // static const String conversations = "$baseUrl/api/messages/conversations";
  // static const String sendMessage = "$baseUrl/api/messages/send";
  // static String getMessages(String conversationId) => "$baseUrl/api/messages/$conversationId";
}
