import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class AIBrain {
  // ✅ Apka Public Server Link (Port 8000)
  static const String _backendUrl =
      'https://8000-firebase-ai-nexus-backend-1766997874464.cluster-mwsteha33jfdowtvzffztbjcj6.cloudworkstations.dev/api/chat';

  final FlutterTts _tts = FlutterTts();

  Future<void> initBrain() async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
  }

  Future<String?> askLaravel(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        try {
          String aiReply = data['candidates'][0]['content']['parts'][0]['text'];
          aiReply = aiReply.replaceAll('*', '');

          speak(aiReply);
          return aiReply;
        } catch (e) {
          return data['reply'] ?? response.body;
        }
      } else {
        return "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Connection Error: $e";
    }
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }
}
