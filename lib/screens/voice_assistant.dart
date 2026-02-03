import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Tumhare project ke imports
import '../theme/app_colors.dart';
import '../widgets/custom_widgets.dart';
import '../services/ai_logic.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with SingleTickerProviderStateMixin {
  // Services
  late stt.SpeechToText _speech;
  final FlutterTts _tts = FlutterTts();
  final AIBrain _brain = AIBrain();

  // Variables
  bool _isListening = false;
  bool _isThinking = false;
  String _status = "INITIALIZING..."; // Top Status Text
  String _aiResponse = "";

  // 🔥 SAFETY TIMER
  Timer? _silenceTimer;

  // Animation
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _brain.initBrain();

    _animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000), // Thoda fast pulse
        lowerBound: 0.9,
        upperBound: 1.1);

    // Auto Start
    _initSystem();
  }

  // 1. SETUP SYSTEM (Voice & Auto-Loop)
  void _initSystem() async {
    // Google/Jarvis Voice Settings
    await _tts.setLanguage("en-US");
    await _tts.setPitch(0.9); // Clear & Natural pitch
    await _tts.setSpeechRate(0.55); // Thoda tezi se bolega (Smart feel)

    // Loop Logic: Jab bolna band kare, turant sunna shuru kare
    _tts.setCompletionHandler(() {
      if (mounted && !_isListening && !_isThinking) {
        _startListening();
      }
    });

    // Welcome Message
    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speak("CodeNetra online. I'm listening, Sir.");
  }

  // 2. ULTRA-FAST LISTENING (Google Assistant Style)
  void _startListening() async {
    if (_isListening || _isThinking) return;

    bool available = await _speech.initialize(
      onError: (val) => _resetSilenceTimer(),
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          if (mounted) {
            setState(() {
              _isListening = false;
              _status = "PROCESSING..."; // Status update
            });
            _animController.stop();
          }
        }
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _status = "LISTENING..."; // Status update
      });
      _animController.repeat(reverse: true);
      _resetSilenceTimer();

      _speech.listen(
        onResult: (val) {
          _silenceTimer?.cancel();
          // Hum text update nahi kar rahe screen pe (Clean Look)

          if (val.finalResult) {
            // Jaise hi user rukega, ye turant fire hoga
            _processVoice(val.recognizedWords);
          }
        },
        // 🔥 SETTINGS FOR SPEED (Google Assistant Feel)
        listenFor: const Duration(seconds: 20),
        pauseFor:
            const Duration(seconds: 2), // 2 sec rukte hi pakad lega (Fast)
        localeId: "en-US",
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    _silenceTimer?.cancel();
    if (mounted) {
      setState(() {
        _isListening = false;
        _animController.stop();
        _status = "TAP TO ACTIVATE";
      });
    }
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    // 60 sec tak wait karega, fir sleep
    _silenceTimer = Timer(const Duration(seconds: 60), () {
      _stopListening();
      _tts.speak("Going to sleep mode, Sir.");
    });
  }

  // 3. INTELLIGENT PROCESSING (Satik Answer Logic)
  void _processVoice(String query) async {
    if (query.trim().isEmpty) {
      _startListening();
      return;
    }

    _speech.stop();
    _silenceTimer?.cancel();

    setState(() {
      _isListening = false;
      _isThinking = true;
      _animController.stop();
      _status = "ANALYZING...";
    });

    // Identity check
    if (query.toLowerCase().contains("who are you")) {
      _finalizeResponse("I am CodeNetra AI, your intelligent assistant, Sir.");
      return;
    }

    // 🔥 THE PERFECT PROMPT (Satik & Smart)
    String prompt = """
    You are CodeNetra-AI. You are talking to your Boss.
    User said: "$query"
    
    INSTRUCTIONS:
    1. Reply in English. Tone: Smart, Professional, Concise.
    2. Length: 2 to 3 sentences (Approx 60-80 words).
    3. QUALITY: Do not be too short. Explain the MAIN point clearly.
    4. Don't waste time on greetings. Give the Answer directly.
    5. If asked a technical question, explain it simply but accurately.
    """;

    String? res = await _brain.askLaravel(prompt);

    _finalizeResponse(res ?? "I didn't catch that, Sir.");
  }

  void _finalizeResponse(String response) async {
    if (mounted) {
      setState(() {
        _isThinking = false;
        _aiResponse = response;
        _status = "ONLINE"; // Wapas normal status
      });
    }
    await _tts.speak(response);
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _silenceTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  // 4. HOLOGRAPHIC UI (Clean & Sci-Fi)
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "CODE NETRA",
      icon: Icons.graphic_eq,
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // STATUS TEXT (HUD Style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                border: Border.all(
                    color: _isListening ? Colors.red : Colors.cyan, width: 1),
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              _status,
              style: GoogleFonts.shareTechMono(
                color: _isListening ? Colors.redAccent : Colors.cyanAccent,
                fontSize: 16,
                letterSpacing: 2.0,
              ),
            ),
          ),

          const SizedBox(height: 50),

          // THE ORB (Glowing)
          GestureDetector(
              onTap: () {
                if (_isListening) {
                  _stopListening();
                } else {
                  _tts.speak("I'm here, Sir.");
                  _startListening();
                }
              },
              child: ScaleTransition(
                  scale: _animController,
                  child: Container(
                      height: 300,
                      width: 300,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : Colors.cyan)
                              .withOpacity(0.3),
                          blurRadius: 60,
                          spreadRadius: 5,
                        )
                      ]),
                      child: ClipOval(
                          child: Stack(alignment: Alignment.center, children: [
                        Image.asset("assets/orb.gif",
                            fit: BoxFit.cover, height: 350, width: 350),

                        // Loading Ring
                        if (_isThinking)
                          const SizedBox(
                            height: 300,
                            width: 300,
                            child: CircularProgressIndicator(
                                color: Colors.cyanAccent, strokeWidth: 1),
                          ),
                      ]))))),

          const SizedBox(height: 50),

          // HOLOGRAPHIC ANSWER DISPLAY
          if (_aiResponse.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                _aiResponse.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    height: 1.4, // Line height for readability
                    shadows: [
                      const Shadow(
                        blurRadius: 8.0,
                        color: Colors.cyan,
                        offset: Offset(0, 0),
                      ),
                    ]),
              ),
            ),

          if (_aiResponse.isEmpty) const Spacer(),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }
}
