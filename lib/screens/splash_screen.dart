import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; // ✅ Animation Package

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
    // ⏱️ Timer increased to 3 seconds to let animation finish
    Timer(const Duration(seconds: 3), () {
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
            // 🔹 1. Logo Container with Bouncy Pop & Shimmer
            Container(
                    padding: const EdgeInsets.all(30), // Slightly bigger
                    decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryAccent.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 10,
                          )
                        ],
                        border: Border.all(
                            color: AppColors.primaryAccent.withOpacity(0.5))),
                    child: const Icon(Icons.code,
                        size: 90, color: AppColors.primaryAccent))
                .animate() // 👈 Animation Start
                .fade(duration: 600.ms)
                .scale(
                    delay: 200.ms,
                    duration: 600.ms,
                    curve: Curves.easeOutBack) // Bouncy Effect
                .then(delay: 200.ms) // Wait a bit
                .shimmer(
                    duration: 1500.ms,
                    color: Colors.white.withOpacity(0.5)), // ✨ Shine Effect

            const SizedBox(height: 40),

            // 🔹 2. Main Title (Slides Up)
            Text("CodeNetra",
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1))
                .animate()
                .fade(duration: 500.ms, delay: 500.ms) // Fades in later
                .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutExpo), // Slides up smoothly

            const SizedBox(height: 10),

            // 🔹 3. Subtitle (Fades in Last)
            Text("Professional AI Suite",
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        letterSpacing: 4)) // Wider spacing looks pro
                .animate()
                .fade(duration: 600.ms, delay: 800.ms), // Comes last

            const SizedBox(height: 60),

            // 🔹 4. Small Loading Indicator (Optional but looks techy)
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryAccent,
              ),
            ).animate().fade(
                duration: 400.ms, delay: 1000.ms) // Appears at the very end
          ],
        ),
      ),
    );
  }
}
