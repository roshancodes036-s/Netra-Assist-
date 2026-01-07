import 'package:google_generative_ai/google_generative_ai.dart';

class AIBrain {
  // ✅ आपकी API Key
  static const String _apiKey = "AIzaSyB8pvagisvGUVIDS0LNzMW_uvEIg6BfAxA";

  late GenerativeModel _model;
  late ChatSession _chat;
  bool _isInitialized = false;

  void initBrain() {
    try {
      _model = GenerativeModel(
        // ✅ FIX: 'gemini-pro' एक स्थिर मॉडल है जो इस API वर्शन के साथ काम करेगा।
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );
      _chat = _model.startChat();
      _isInitialized = true;
      print("✅ CodeNetra Brain: ACTIVE ('gemini-2.5-flash',)");
    } catch (e) {
      print("❌ Brain Error: $e");
    }
  }

  Future<String?> askLaravel(String prompt) async {
    try {
      if (!_isInitialized) {
        initBrain();
      }
      final content = Content.text(prompt);
      final response = await _chat.sendMessage(content);
      return response.text;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  void stopSpeaking() {}
}
