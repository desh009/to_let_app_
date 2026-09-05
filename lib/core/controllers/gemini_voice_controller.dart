import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:to_let_app_abandon/core/constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../screens/filter/controllers/filter_controller.dart';
import '../../screens/home/controllers/home_controller.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/nav/nav_controller.dart';
import '../services/gemini_voice_service.dart';

class GeminiVoiceController extends GetxController {
  static GeminiVoiceController get to {
    if (!Get.isRegistered<GeminiVoiceController>()) {
      return Get.put(GeminiVoiceController(), permanent: true);
    }
    return Get.find<GeminiVoiceController>();
  }

  final GeminiVoiceService _voiceService = GeminiVoiceService();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  final RxBool isSpeechAvailable = false.obs;
  final RxBool isListening = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString recognizedText = ''.obs;
  final RxString statusMessage = 'Tap mic & speak your command...'.obs;
  final RxString aiReplyText = ''.obs;
  final Rxn<GeminiVoiceIntent> currentIntent = Rxn<GeminiVoiceIntent>();

  final TextEditingController textInputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initSpeechAndTts();
  }

  Future<void> _initSpeechAndTts() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
            if (recognizedText.value.isNotEmpty && !isProcessing.value) {
              processSpeechCommand(recognizedText.value);
            }
          }
        },
        onError: (errorNotification) {
          isListening.value = false;
          statusMessage.value = 'Speech recognition error. Try typing below.';
        },
      );
      isSpeechAvailable.value = available;
    } catch (e) {
      isSpeechAvailable.value = false;
      debugPrint('Speech init error: $e');
    }

    try {
      await _tts.setLanguage('bn-BD');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  // Public method to start listening directly
  void startListening() => _startListening();

  Future<void> _startListening() async {
    aiReplyText.value = '';
    recognizedText.value = '';
    currentIntent.value = null;

    if (!isSpeechAvailable.value) {
      final available = await _speech.initialize();
      isSpeechAvailable.value = available;
      if (!available) {
        statusMessage.value = 'Microphone permission not granted or available.';
        CustomSnackbar.showError(
          title: 'Mic Unavailable',
          message: 'Please enable microphone access or type your request below.',
        );
        return;
      }
    }

    statusMessage.value = 'Listening... Speak now!';
    isListening.value = true;

    try {
      await _speech.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
          if (result.finalResult) {
            isListening.value = false;
            processSpeechCommand(result.recognizedWords);
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: 'bn_BD',
          listenFor: const Duration(seconds: 8),
          pauseFor: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      isListening.value = false;
      statusMessage.value = 'Could not start microphone.';
    }
  }

  void stopListening() async {
    if (isListening.value) {
      await _speech.stop();
      isListening.value = false;
      if (recognizedText.value.isNotEmpty) {
        processSpeechCommand(recognizedText.value);
      }
    }
  }

  void toggleListening() {
    if (isListening.value) {
      stopListening();
    } else {
      _startListening();
    }
  }

  Future<void> processSpeechCommand(String query) async {
    if (query.trim().isEmpty) return;

    isProcessing.value = true;
    statusMessage.value = 'Gemini AI processing...';

    // Read API key from .env
    final apiKey = dotenv.maybeGet('GEMINI_API_KEY');
    final hasValidKey = apiKey != null &&
        apiKey.isNotEmpty &&
        apiKey != 'your_gemini_api_key_here';

    try {
      final intent = await _voiceService.processCommand(
        query,
        apiKey: hasValidKey ? apiKey : null,
      );
      currentIntent.value = intent;
      aiReplyText.value = intent.replyText;
      statusMessage.value = intent.replyText;

      // Speak back
      _speak(intent.replyText);

      // Show floating feedback snackbar
      CustomSnackbar.showInfo(
        title: 'Gemini Voice Assistant',
        message: intent.replyText,
        duration: const Duration(seconds: 4),
      );

      // Execute intent actions
      await _executeIntent(intent);
    } catch (e) {
      statusMessage.value = 'Failed to process command. Please try again.';
      debugPrint('Process speech error: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> submitTypedText() async {
    final text = textInputController.text.trim();
    if (text.isNotEmpty) {
      recognizedText.value = text;
      textInputController.clear();
      await processSpeechCommand(text);
    }
  }

  Future<void> _executeIntent(GeminiVoiceIntent intent) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (intent.action == VoiceIntentAction.navigate) {
      _handleNavigation(intent);
    } else if (intent.action == VoiceIntentAction.search) {
      _handleSearch(intent);
    }
  }

  void _handleNavigation(GeminiVoiceIntent intent) {
    final navController = Get.find<NavController>();

    if (intent.targetTabIndex != null) {
      navController.changeTab(intent.targetTabIndex!);
    }

    if (intent.targetRoute != null) {
      switch (intent.targetRoute) {
        case Routes.PROFILE:
          navController.toProfile();
          break;
        case Routes.SAVED:
          navController.toSaved();
          break;
        case Routes.MESSAGES:
          navController.toMessages();
          break;
        case Routes.HOME:
          navController.toHome();
          break;
        case Routes.NOTIFICATIONS:
          Get.toNamed(Routes.NOTIFICATIONS);
          break;
        case Routes.FILTER:
          Get.toNamed(Routes.FILTER);
          break;
        default:
          Get.toNamed(intent.targetRoute!);
      }
    }
  }

  void _handleSearch(GeminiVoiceIntent intent) {
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();

      if (intent.location != null && intent.location!.isNotEmpty) {
        homeCtrl.updateLocation(intent.location!);
        homeCtrl.updateSearchQuery(intent.location!);
      }

      if (intent.category != null && intent.category!.isNotEmpty) {
        homeCtrl.selectCategory(intent.category!);
      }

      // Sync filter controller if registered
      if (Get.isRegistered<FilterController>()) {
        final filterCtrl = Get.find<FilterController>();
        if (intent.location != null && intent.location!.isNotEmpty) {
          filterCtrl.selectedSubLocation.value = intent.location!;
        }
        if (intent.category != null && intent.category!.isNotEmpty) {
          filterCtrl.selectedPropertyType.value = intent.category!;
        }
        if (intent.bedrooms != null) {
          filterCtrl.selectedBedrooms.value = intent.bedrooms!;
        }
        if (intent.maxPrice != null) {
          filterCtrl.updatePriceRange(RangeValues(1000, intent.maxPrice!));
        }
      }

      // Check results count
      final results = homeCtrl.recommendedProperties.length + homeCtrl.featuredProperties.length;
      final speechNotice = results > 0
          ? '$results টি বাসা পাওয়া গেছে!'
          : 'নতুন বাসা খুঁজতে ফিল্টার রেজাল্টে চলুন।';

      _speak(speechNotice);

      // Navigate to Filter Results Screen to show matching listings
      Get.toNamed(Routes.FILTER_RESULTS);
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  @override
  void onClose() {
    _speech.stop();
    _tts.stop();
    textInputController.dispose();
    super.onClose();
  }
}
