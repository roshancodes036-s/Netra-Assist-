import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import 'home_layout.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // ⏱️ Timer set to 3.5 seconds to enjoy the new animation
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainLayout(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 1. Vision Icon Container with Bouncy Pop & Shimmer
            Container(
                    padding: const EdgeInsets.all(35), 
                    decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryAccent.withValues(alpha: 0.25),
                            blurRadius: 40,
                            spreadRadius: 15,
                          )
                        ],
                        border: Border.all(
                            color: AppColors.primaryAccent.withValues(alpha: 0.5),
                            width: 2)),
                    // ✅ FIXED: Changed Icon to match Netra vision
                    child: const Icon(Icons.remove_red_eye,
                        size: 90, color: AppColors.primaryAccent))
                .animate() // 👈 Animation Start
                .fade(duration: 600.ms)
                .scale(
                    delay: 200.ms,
                    duration: 700.ms,
                    curve: Curves.easeOutBack) // Bouncy Effect
                .then(delay: 300.ms) 
                .shimmer(
                    duration: 1500.ms,
                    color: Colors.white.withValues(alpha: 0.6)), // ✨ Shine Effect

            const SizedBox(height: 45),

            // 🔹 2. Main Title (Slides Up)
            Text("Netra Assist", // ✅ FIXED: App Name Changed
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1))
                .animate()
                .fade(duration: 600.ms, delay: 600.ms) // Fades in later
                .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOutExpo), // Slides up smoothly

            const SizedBox(height: 12),

            // 🔹 3. Subtitle (Social Good Focused)
            Text("EMPOWERING VISION WITH AI", // ✅ FIXED: Powerful Social Good Tagline
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 5)) // Wider spacing looks pro
                .animate()
                .fade(duration: 800.ms, delay: 1000.ms), // Comes last

            const SizedBox(height: 70),

            // 🔹 4. Small Loading Indicator
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryAccent,
              ),
            ).animate().fade(
                duration: 500.ms, delay: 1400.ms) 
          ],
        ),
      ),
    );
  }
}