import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../routes/app_routes.dart';

enum VoiceIntentAction {
  navigate,
  search,
  generalReply,
  unknown,
}

class GeminiVoiceIntent {
  final VoiceIntentAction action;
  final String? targetRoute;
  final int? targetTabIndex; // 0: Home, 1: Saved, 2: Messages, 3: Profile
  final String? location;
  final String? category; // Family, Bachelor, Sublet, Seat
  final double? maxPrice;
  final String? bedrooms;
  final String replyText;

  GeminiVoiceIntent({
    required this.action,
    this.targetRoute,
    this.targetTabIndex,
    this.location,
    this.category,
    this.maxPrice,
    this.bedrooms,
    required this.replyText,
  });
}

class GeminiVoiceService {
  static const String _defaultGeminiModel = 'gemini-1.5-flash';

  /// Processes user speech command using Gemini API with intelligent fallback rule parsing
  Future<GeminiVoiceIntent> processCommand(
    String userQuery, {
    String? apiKey,
  }) async {
    final cleanQuery = userQuery.trim();
    if (cleanQuery.isEmpty) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.generalReply,
        replyText: 'অনুগ্রহ করে কি সার্চ করতে চান বলুন।',
      );
    }

    // Try Gemini API first if API key is present
    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        final geminiIntent = await _callGeminiApi(cleanQuery, apiKey);
        if (geminiIntent != null) {
          return geminiIntent;
        }
      } catch (e) {
        debugPrint('Gemini API call error: $e. Falling back to local NLP engine.');
      }
    }

    // Local Bengali & English Rule-Based Intelligent NLP Parser
    return _parseLocalNLP(cleanQuery);
  }

  /// Calls Google Gemini API for structured JSON Intent Extraction
  Future<GeminiVoiceIntent?> _callGeminiApi(
    String userQuery,
    String apiKey,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_defaultGeminiModel:generateContent?key=$apiKey',
    );

    final prompt = '''
You are the AI assistant for a "To-Let" Property Rental App in Bangladesh, focusing heavily on Khulna city & surrounding areas.
Analyze the user's voice command: "$userQuery"
Key Khulna Locations to recognize: Daulatpur, Shiromoni, Sonadanga, Khalishpur, Boyra, Nirala, KUET, Fulbarigate, Moylapota, Shibbari, Gollamari, Rupsha, Phultala, Khan Jahan Ali, Mujgunni, Pabla, Maheshwarpasha, KDA Avenue, Royal Mor, Dakbangla, Tutpara, Labanchara, Teligati, Gilatala, Khulna Sadar.

Return strictly a valid JSON object without markdown formatting:
{
  "action": "navigate" | "search" | "generalReply",
  "targetRoute": "/profile" | "/saved" | "/messages" | "/post-listing" | "/notifications" | "/home" | "/filter" | null,
  "targetTabIndex": 0 (Home), 1 (Saved), 2 (Messages), 3 (Profile) or null,
  "location": "location name e.g. Daulatpur, Shiromoni, Sonadanga, KUET, Khulna" or null,
  "category": "Family" | "Bachelor" | "Sublet" | "Seat" or null,
  "maxPrice": number or null,
  "bedrooms": "1" | "2" | "3" | "4+" or null,
  "replyText": "Natural, helpful, short response in Bengali explaining the action being taken."
}
''';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'maxOutputTokens': 250,
      }
    });

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 6));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final rawContent = jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
      
      final jsonString = _extractJson(rawContent);
      if (jsonString != null) {
        final parsed = jsonDecode(jsonString);
        return _mapJsonToIntent(parsed, userQuery);
      }
    }
    return null;
  }

  String? _extractJson(String text) {
    try {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        return text.substring(start, end + 1);
      }
    } catch (_) {}
    return null;
  }

  GeminiVoiceIntent _mapJsonToIntent(Map<String, dynamic> json, String originalQuery) {
    final actionStr = (json['action'] ?? '').toString().toLowerCase();
    VoiceIntentAction action;
    if (actionStr == 'navigate') {
      action = VoiceIntentAction.navigate;
    } else if (actionStr == 'search') {
      action = VoiceIntentAction.search;
    } else {
      action = VoiceIntentAction.generalReply;
    }

    return GeminiVoiceIntent(
      action: action,
      targetRoute: json['targetRoute'] as String?,
      targetTabIndex: json['targetTabIndex'] is int ? json['targetTabIndex'] : null,
      location: json['location'] as String?,
      category: json['category'] as String?,
      maxPrice: (json['maxPrice'] is num) ? (json['maxPrice'] as num).toDouble() : null,
      bedrooms: json['bedrooms']?.toString(),
      replyText: json['replyText']?.toString() ?? 'আপনার অনুরোধ প্রসেস করা হচ্ছে...',
    );
  }

  /// Local High-Precision NLP Parser for Bengali and English Voice Commands
  GeminiVoiceIntent _parseLocalNLP(String query) {
    final lower = query.toLowerCase();

    // 1. Navigation Commands
    if (_matchesAny(lower, ['profile', 'প্রোফাইল', 'মাই প্রোফাইল', 'my profile', 'account', 'অ্যাকাউন্ট'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.PROFILE,
        targetTabIndex: 3,
        replyText: 'প্রোফাইল পেজে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    if (_matchesAny(lower, ['saved', 'সেভড', 'ফেভারিট', 'favorite', 'favourites', 'পছন্দ'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.SAVED,
        targetTabIndex: 1,
        replyText: 'আপনার সেভ করা বাসাগুলির লিস্টে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    if (_matchesAny(lower, ['message', 'messages', 'মেসেজ', 'ইনবক্স', 'inbox', 'chat', 'চ্যাট'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.MESSAGES,
        targetTabIndex: 2,
        replyText: 'মেসেজ ইনবক্সে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    if (_matchesAny(lower, ['post', 'post listing', 'পোস্ট', 'বিজ্ঞাপন', 'add post', 'নতুন বাসা'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.POST_LISTING,
        replyText: 'বাসার টু-লেট পোস্ট করার পেজে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    if (_matchesAny(lower, ['notification', 'notifications', 'নোটিফিকেশন', 'বিজ্ঞপ্তি'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.NOTIFICATIONS,
        replyText: 'নোটিফিকেশন পেজে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    if (_matchesAny(lower, ['home', 'হোম', 'মূল পাতা', 'প্রথম পাতা', 'main screen'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.HOME,
        targetTabIndex: 0,
        replyText: 'হোম পেজে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    if (_matchesAny(lower, ['filter', 'ফিল্টার'])) {
      return GeminiVoiceIntent(
        action: VoiceIntentAction.navigate,
        targetRoute: Routes.FILTER,
        replyText: 'ফিল্টার পেজে নিয়ে যাওয়া হচ্ছে...',
      );
    }

    // 2. Search & Location Commands
    // Extract potential category
    String? category;
    if (_matchesAny(lower, ['bachelor', 'ব্যাচেলর'])) {
      category = 'Bachelor';
    } else if (_matchesAny(lower, ['family', 'ফ্যামিলি', 'পরিবার'])) {
      category = 'Family';
    } else if (_matchesAny(lower, ['sublet', 'সাবলেট'])) {
      category = 'Sublet';
    } else if (_matchesAny(lower, ['seat', 'সিট'])) {
      category = 'Seat';
    }

    // Extract room numbers
    String? bedrooms;
    if (_matchesAny(lower, ['1 room', '1 bedroom', 'এক রুম', '১ রুম', '1bhk'])) {
      bedrooms = '1';
    } else if (_matchesAny(lower, ['2 room', '2 bedroom', 'দুই রুম', '২ রুম', '2bhk'])) {
      bedrooms = '2';
    } else if (_matchesAny(lower, ['3 room', '3 bedroom', 'তিন রুম', '৩ রুম', '3bhk'])) {
      bedrooms = '3';
    } else if (_matchesAny(lower, ['4 room', 'চার রুম', '৪ রুম'])) {
      bedrooms = '4+';
    }

    // Extract price if numbers are present
    double? maxPrice;
    final priceMatch = RegExp(r'(\d+)\s*(হাজার|k|tk|টাকা)?', caseSensitive: false).firstMatch(lower);
    if (priceMatch != null) {
      final numStr = priceMatch.group(1);
      final unit = priceMatch.group(2)?.toLowerCase() ?? '';
      if (numStr != null) {
        double val = double.tryParse(numStr) ?? 0;
        if (unit.contains('হাজার') || unit == 'k') {
          val *= 1000;
        }
        if (val >= 1000) {
          maxPrice = val;
        }
      }
    }

    // Extract location - Comprehensive Khulna City & Area Coverage
    final locationsList = [
      // English Names & Variations
      'Shiromoni', 'Siromoni', 'Daulatpur', 'Doulatpur', 'Sonadanga', 'Khalishpur',
      'Boyra', 'Boira', 'Choto Boyra', 'Boro Boyra', 'Nirala', 'Moylapota', 'Shibbari',
      'Gollamari', 'Rupsha', 'KUET', 'Kuet', 'Phultala', 'Fultola', 'Fulbarigate', 'Phulbarigate',
      'Khan Jahan Ali', 'Mujgunni', 'Railgate', 'Pabla', 'Maheshwarpasha',
      'KDA Avenue', 'KDA Bypass', 'KDA', 'Royal Mor', 'Royal Circle', 'Dakbangla',
      'Custom Ghat', 'Ferrighat', 'Tutpara', 'Labanchara', 'Joraghat', 'Teligati', 'Gilatala',
      'Bastuhara', 'Rayer Mahal', 'Baniakhamar', 'Picture Palace', 'Shantidham',
      'Sheikhpara', 'Basupara', 'Power House Mor', 'BL College', 'City College',
      'Medical College', 'Khulna University', 'Khulna Sadar', 'Khulna',
      'Mirpur', 'Dhanmondi', 'Uttara', 'Gulshan', 'Banani',

      // Bengali Names & Variations
      'শিরোমণি', 'শিরোমনি', 'দৌলতপুর', 'সোনাডাঙ্গা', 'সোনাডাঙা', 'খালিশপুর',
      'বয়রা', 'বইরা', 'ছোট বয়রা', 'বড় বয়রা', 'নিরালা', 'ময়লাপোতা', 'শিববাড়ী', 'শিববাড়ি',
      'গল্লামারী', 'গল্লামারি', 'রূপসা', 'রূপশা', 'কুয়েট', 'ফুলতলা', 'ফুলবাড়ীগেট', 'ফুলবাড়িগেট',
      'রেলগেট', 'পাবলা', 'মহেশ্বরপাশা', 'কেডিএ', 'কেডিএ বাইপাস', 'রয়্যাল মোড়', 'রয়েল মোড়',
      'ডাকবাংলা', 'টুটপাড়া', 'টুটপাড়া', 'লবণচরা', 'তেলীগাতী', 'গিলাতলা', 'বাস্তুহারা',
      'রায়ের মহল', 'বানিয়াকামার', 'পিকচার প্যালেস', 'শান্তিধাম', 'শেখপাড়া', 'বসুিপাড়া',
      'পাওয়ার হাউস মোড়', 'বি এল কলেজ', 'সিটি কলেজ', 'মেডিকেল কলেজ', 'খুলনা বিশ্ববিদ্যালয়', 'খুলনা',
      'মিরপুর', 'ধানমন্ডি', 'উত্তরা', 'গুলশান', 'বনানী'
    ];

    String? matchedLocation;
    for (final loc in locationsList) {
      if (lower.contains(loc.toLowerCase())) {
        matchedLocation = loc;
        break;
      }
    }

    // If search indicators or location present
    final isSearchQuery = matchedLocation != null ||
        category != null ||
        bedrooms != null ||
        maxPrice != null ||
        _matchesAny(lower, ['search', 'খুঁজ', 'খুজ', 'বাসা', 'ফ্ল্যাট', 'খালি', 'ভাড়া', 'vada', 'basa', 'flat', 'rent']);

    if (isSearchQuery) {
      final locText = matchedLocation != null ? '$matchedLocation-এ ' : '';
      final catText = category != null ? '$category ' : '';
      final roomText = bedrooms != null ? '$bedrooms রুমের ' : '';
      final reply = '${locText}${catText}${roomText}বাসা খোঁজা হচ্ছে...';

      return GeminiVoiceIntent(
        action: VoiceIntentAction.search,
        location: matchedLocation ?? query,
        category: category,
        bedrooms: bedrooms,
        maxPrice: maxPrice,
        replyText: reply,
      );
    }

    // Fallback general response
    return GeminiVoiceIntent(
      action: VoiceIntentAction.search,
      location: query,
      replyText: '"$query" অনুযায়ী বাসা খোঁজা হচ্ছে...',
    );
  }

  bool _matchesAny(String input, List<String> keywords) {
    for (final kw in keywords) {
      if (input.contains(kw)) return true;
    }
    return false;
  }
}
