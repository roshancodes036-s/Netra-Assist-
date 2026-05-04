import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../widgets/custom_widgets.dart';

// ✅ ONLY NETRA/SOCIAL GOOD SCREENS IMPORTED
import 'vision_mode.dart';
import 'voice_assistant.dart';
import 'pdf_mind.dart';
import 'visual_qa.dart';
import 'face_emotion.dart';

// Upgrade Screen Placeholder
class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});
  @override
  Widget build(BuildContext context) => const ProPageLayout(
      title: "Upgrade",
      icon: Icons.bolt,
      child: Center(child: Text("Pro Plan")));
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void _changeScreen(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    // ✅ MASTER LIST OF SCREENS (Only Accessibility Features)
    final List<Widget> screens = [
      HomeScreen(onNavigate: _changeScreen), // 0

      // --- NETRA TOOLS ---
      const LiveCameraScreen(), // 1
      const VoiceScreen(), // 2
      const PDFScreen(), // 3
      const VisualQAScreen(), // 4
      const FaceEmotionScreen(), // 5
      
      const UpgradeScreen(), // 6
    ];

    // Safety check
    final safeIndex = _selectedIndex < screens.length ? _selectedIndex : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withAlpha(128)))),
        title: _buildAppBarTitle(),
        centerTitle: true,
        leading: Builder(
            builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: AppColors.primaryAccent, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer())),
      ),
      drawer: Drawer(
          width: 280,
          backgroundColor: AppColors.backgroundDark,
          child: SidebarContent(
              selectedIndex: _selectedIndex,
              onTap: (index) {
                _changeScreen(index);
                Navigator.pop(context);
              })),
      // ✨ Smooth Fade Transition between screens
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: screens[safeIndex]),
    );
  }

  Widget _buildAppBarTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.borderSubtle)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.visibility_rounded, color: AppColors.primaryAccent, size: 18),
        const SizedBox(width: 10),
        Text("Netra Assist Mode",
            style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ]),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -1, end: 0); // AppBar Animation
  }
}

// -----------------------------------------------------------------------------
// 🔥 SIDEBAR CONTENT
// -----------------------------------------------------------------------------
class SidebarContent extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  
  const SidebarContent(
      {super.key,
      required this.selectedIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.backgroundDark,
        child: Column(children: [
          const SizedBox(height: 60),
          // ✅ RENAMED TO NETRA ASSIST
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.remove_red_eye,
                color: AppColors.primaryAccent, size: 32),
            const SizedBox(width: 10),
            Text("Netra Assist",
                style: GoogleFonts.outfit(
                    fontSize: 26, fontWeight: FontWeight.w800))
          ]).animate().fadeIn().scale(), // Logo Pop

          const SizedBox(height: 40), // Removed the toggle switch area

          Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header("ACCESSIBILITY SUITE"),
                        _btn("Dashboard", Icons.dashboard_rounded, 0),

                        // 🔥 ONLY NETRA BUTTONS (Indexes updated)
                        _btn("Live Vision", Icons.camera_enhance_rounded, 1),
                        _btn("Voice Assistant", Icons.graphic_eq_rounded, 2),
                        _btn("PDF Intelligence", Icons.picture_as_pdf_rounded, 3),
                        _btn("Visual Q&A", Icons.help_outline, 4),
                        _btn("Face & Emotion", Icons.face_retouching_natural, 5),
                      ]
                          // Staggered List Animation
                          .animate(interval: 50.ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.1, end: 0)))),
          _btn("Upgrade Plan", Icons.bolt_rounded, 6),
          const SizedBox(height: 20),
        ]));
  }

  Widget _header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 8, 8),
      child: Text(text,
          style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1)));
              
  Widget _btn(String title, IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
        margin: const EdgeInsets.only(bottom: 6),
        child: ListTile(
            onTap: () => onTap(index),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            tileColor: isSelected
                ? AppColors.primaryAccent.withAlpha(38)
                : Colors.transparent,
            leading: Icon(icon,
                color: isSelected
                    ? AppColors.primaryAccent
                    : AppColors.textSecondary,
                size: 24),
            title: Text(title,
                style: GoogleFonts.outfit(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 16)),
            dense: true));
  }
}

// -----------------------------------------------------------------------------
// 🔥 HOME SCREEN (With Tagda Animation)
// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 1️⃣ Header Animation
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Hello, Netra User",
                  style: GoogleFonts.outfit(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // ✅ HARDCODED STATUS BADGE TO AVOID ERRORS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withAlpha(100))
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 10),
                    const SizedBox(width: 6),
                    Text("Vision Intelligence Active", 
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ]),
            const CircleAvatar(
                backgroundColor: AppColors.cardSurface,
                child: Icon(Icons.person, color: Colors.white))
          ])
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.2, end: 0, curve: Curves.easeOut),

          const SizedBox(height: 30),

          // 2️⃣ BIG CARD - LIVE VISION (Index updated to 1)
          _largeActionCard(
                  title: "Live Vision",
                  subtitle: "Identify Objects & Read Text",
                  icon: Icons.remove_red_eye,
                  color: AppColors.primaryAccent,
                  onTap: () => onNavigate(1))
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms) 
              .slideY(
                  begin: 0.2, end: 0, curve: Curves.easeOutBack) 
              .shimmer(
                  delay: 1200.ms,
                  duration: 1500.ms,
                  color: Colors.white.withAlpha(102)), 

          const SizedBox(height: 20),

          // 3️⃣ SMALL CARDS GRID - VISUAL Q&A AND EMOTION SCAN
          Row(children: [
             Expanded(
                 child: _smallCard("Visual Q&A", Icons.help_outline,
                         Colors.pink, () => onNavigate(4)) // Index 4
                     .animate()
                     .fadeIn(delay: 400.ms)
                     .slideX(begin: -0.2, end: 0)),
             const SizedBox(width: 15),
             Expanded(
                 child: _smallCard("Emotion Scan", Icons.face, Colors.purple,
                         () => onNavigate(5)) // Index 5
                     .animate()
                     .fadeIn(delay: 500.ms)
                     .slideX(begin: 0.2, end: 0))
          ])
        ]));
  }

  Widget _largeActionCard(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [color.withAlpha(204), color]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: color.withAlpha(102),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ]),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Icon(icon, size: 32, color: Colors.black),
                    const SizedBox(height: 12),
                    Text(title,
                        style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Text(subtitle,
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500))
                  ])),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.black, size: 32)
            ])));
  }

  Widget _smallCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: color.withAlpha(26), shape: BoxShape.circle),
                  child: Icon(icon, color: color)),
              const SizedBox(height: 15),
              Text(title,
                  style: GoogleFonts.outfit(
                      fontSize: 18, fontWeight: FontWeight.bold))
            ])));
  }
}