import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

// ✅ FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ✅ BRAIN
import 'ai_logic.dart';

// =============================================================================
// ✨ PROFESSIONAL THEME COLORS
// =============================================================================
class AppColors {
  static const Color primaryAccent = Color(0xFFCCFF00); // Neon Green Highlight
  static const Color backgroundDark = Color(0xFF0A0A0A); // Deepest Black
  static const Color cardSurface = Color(0xFF1C1C1C); // Premium Grey Card
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color borderSubtle = Color(0xFF333333);
}

// =============================================================================
// MAIN ENTRY
// =============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // debugPrint("Firebase Error: $e");
  }

  // Set Status Bar to Dark
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.backgroundDark,
  ));

  runApp(const CodeNetraApp());
}

class CodeNetraApp extends StatelessWidget {
  const CodeNetraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeNetra AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.primaryAccent,
        canvasColor: AppColors.backgroundDark,
        useMaterial3: true,
        // Professional Typography using Inter font
        textTheme:
            GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.backgroundDark,
        ),
      ),
      home: const SplashView(),
    );
  }
}

// =============================================================================
// 1. PROFESSIONAL SPLASH SCREEN (Cleaner Animation)
// =============================================================================

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
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
            // Subtle glowing logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.code,
                  size: 80, color: AppColors.primaryAccent),
            ),
            const SizedBox(height: 30),
            Text("CodeNetra",
                style: GoogleFonts.inter(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1)),
            const SizedBox(height: 10),
            Text("Professional AI Suite",
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 2. MAIN LAYOUT (Clean Structure)
// =============================================================================

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isDevMode = true;

  void _changeScreen(int index) => setState(() => _selectedIndex = index);

  void _toggleMode(bool isDev) {
    setState(() {
      _isDevMode = isDev;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigate: _changeScreen, isDevMode: _isDevMode), // 0
      const RepoChatScreen(), // 1
      const TemplatesScreen(), // 2
      const ErrorFixerScreen(), // 3
      const UIToCodeScreen(), // 4
      const PDFScreen(), // 5
      const VoiceScreen(), // 6
      const UpgradeScreen(), // 7
      const LiveCameraScreen(), // 8
      const CodeExpertScreen(), // 9
    ];

    bool isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: SidebarContent(
          selectedIndex: _selectedIndex,
          isDevMode: _isDevMode,
          onModeChange: _toggleMode,
          onTap: (index) {
            _changeScreen(index);
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          if (isWide)
            SizedBox(
                width: 280,
                child: SidebarContent(
                    selectedIndex: _selectedIndex,
                    isDevMode: _isDevMode,
                    onModeChange: _toggleMode,
                    onTap: _changeScreen)),
          Expanded(
            // Using a subtle fade transition for screen changes
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  screens[_selectedIndex < screens.length ? _selectedIndex : 0],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_isDevMode ? Icons.terminal_rounded : Icons.visibility_rounded,
              color: AppColors.primaryAccent, size: 18),
          const SizedBox(width: 10),
          Text(_isDevMode ? "Developer Mode" : "Netra Vision Mode",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

// --- PROFESSIONAL SIDEBAR ---

class SidebarContent extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isDevMode;
  final Function(bool) onModeChange;

  const SidebarContent({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.isDevMode,
    required this.onModeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDark,
      child: Column(
        children: [
          const SizedBox(height: 50),
          // Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.code_rounded,
                  color: AppColors.primaryAccent, size: 28),
              const SizedBox(width: 10),
              Text("CodeNetra",
                  style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w800)),
            ],
          ),

          const SizedBox(height: 30),
          // Professional Toggle Switch
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                _modeButton("Code", Icons.code_rounded, true),
                _modeButton("Netra", Icons.visibility_rounded, false),
              ],
            ),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(isDevMode ? "DEVELOPMENT" : "ACCESSIBILITY"),
                  _btn("Dashboard", Icons.dashboard_rounded, 0),
                  if (isDevMode) ...[
                    _btn("Repo Chat", Icons.folder_zip_rounded, 1),
                    _btn("UI to Code", Icons.image_aspect_ratio_rounded, 4),
                    _btn("Error Debugger", Icons.bug_report_rounded, 3),
                    _btn("Code Expert", Icons.terminal_rounded, 9),
                    _btn("Documentation", Icons.description_rounded, 2),
                  ] else ...[
                    _btn("Live Vision", Icons.camera_enhance_rounded, 8),
                    _btn("Voice Assistant", Icons.graphic_eq_rounded, 6),
                    _btn("PDF Intelligence", Icons.picture_as_pdf_rounded, 5),
                    _btn("Content Studio", Icons.edit_note_rounded, 2),
                  ],
                ],
              ),
            ),
          ),

          // Professional Upgrade Banner
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.primaryAccent.withOpacity(0.1),
                  AppColors.cardSurface
                ]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primaryAccent.withOpacity(0.3))),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(7),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: AppColors.primaryAccent,
                              shape: BoxShape.circle),
                          child: const Icon(Icons.bolt_rounded,
                              color: Colors.black, size: 20)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upgrade to Pro",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold)),
                          Text("Unlock Gemini 1.5 Ultra",
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _modeButton(String text, IconData icon, bool isForDev) {
    bool isActive = isDevMode == isForDev;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChange(isForDev),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isActive ? Colors.black : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(text,
                  style: TextStyle(
                      color: isActive ? Colors.black : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Text(text,
          style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2)));

  Widget _btn(String title, IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: () => onTap(index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected
            ? AppColors.primaryAccent.withOpacity(0.1)
            : Colors.transparent,
        leading: Icon(icon,
            color:
                isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
            size: 22),
        title: Text(title,
            style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
      ),
    );
  }
}

// =============================================================================
// 3. HOME SCREEN (Premium Dashboard Look)
// =============================================================================

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  final bool isDevMode;

  const HomeScreen(
      {super.key, required this.onNavigate, required this.isDevMode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isDevMode ? "Hello, Developer." : "Hello, User.",
                      style: GoogleFonts.inter(
                          fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                      isDevMode
                          ? "Let's build something."
                          : "How can I assist you?",
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 16)),
                ],
              ),
              CircleAvatar(
                backgroundColor: AppColors.cardSurface,
                radius: 24,
                child: const Icon(Icons.person_rounded,
                    color: AppColors.textSecondary),
              )
            ],
          ),

          const SizedBox(height: 30),

          // Hero Action Card
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onNavigate(isDevMode ? 1 : 8),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.primaryAccent,
                      AppColors.primaryAccent.withOpacity(0.8)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primaryAccent.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                shape: BoxShape.circle),
                            child: Icon(
                                isDevMode
                                    ? Icons.terminal_rounded
                                    : Icons.camera_enhance_rounded,
                                color: Colors.black,
                                size: 28)),
                        const SizedBox(height: 20),
                        Text(isDevMode ? "Start Coding" : "Open Live Vision",
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w800)),
                        Text(
                            isDevMode
                                ? "Fix bugs & generate logic"
                                : "Describe surroundings",
                            style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.black, size: 32)
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Secondary Action Card
          ProCard(
            onTap: () => onNavigate(isDevMode ? 4 : 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: Icon(
                      isDevMode
                          ? Icons.image_aspect_ratio_rounded
                          : Icons.graphic_eq_rounded,
                      color: AppColors.primaryAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isDevMode ? "UI to Code" : "Voice Assistant",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      Text(
                          isDevMode
                              ? "Convert designs to Flutter"
                              : "Speak naturally with AI",
                          style: GoogleFonts.inter(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary)
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Quick stats or info can go here for a pro feel
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      "Projects", "12", Icons.folder_open_rounded)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      "API Usage", "85%", Icons.bar_chart_rounded)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return ProCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(height: 12),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 24, fontWeight: FontWeight.w800)),
            Text(title,
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 🔥 4. PROFESSIONAL FEATURE SCREENS (Using ProCard)
// =============================================================================

// 1. REPO CHAT SCREEN
class RepoChatScreen extends StatelessWidget {
  const RepoChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "Repo Chat",
      icon: Icons.folder_zip_rounded,
      child: Column(
        children: [
          ProCard(
            child: ListTile(
              leading: const Icon(Icons.folder_zip, color: Colors.orange),
              title: const Text("CodeNetra_v2.zip",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("indexed • 2.4 MB",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              trailing: const Icon(Icons.check_circle,
                  color: AppColors.primaryAccent),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded,
                      size: 60, color: AppColors.borderSubtle),
                  const SizedBox(height: 20),
                  Text("Ask questions about your codebase",
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          _buildProInput("Search repositry context..."),
        ],
      ),
    );
  }
}

// 2. UI TO CODE SCREEN
class UIToCodeScreen extends StatelessWidget {
  const UIToCodeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "UI to Code",
      icon: Icons.image_aspect_ratio_rounded,
      child: Column(
        children: [
          const Text("Upload a design screenshot, get clean Flutter code.",
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 30),
          // Upload Area
          Expanded(
            flex: 1,
            child: ProCard(
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_rounded,
                          size: 50, color: AppColors.primaryAccent),
                      const SizedBox(height: 16),
                      Text("Click to Upload Screenshot",
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      Text("PNG, JPG accepted",
                          style: GoogleFonts.inter(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Code Preview Area
          Expanded(
            flex: 2,
            child: ProCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.code_rounded,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text("Generated Code",
                            style: GoogleFonts.inter(
                                color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "// Flutter code will appear here...\n\nclass MyGeneratedWidget extends StatelessWidget {\n  const MyGeneratedWidget({super.key});\n  @override\n  Widget build(BuildContext context) {\n    return Container(\n      color: Colors.black,\n      child: Column(...\n",
                        style: GoogleFonts.firaCode(
                            color: AppColors.primaryAccent.withOpacity(0.8),
                            fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. ERROR FIXER SCREEN
class ErrorFixerScreen extends StatelessWidget {
  const ErrorFixerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "Error Debugger",
      icon: Icons.bug_report_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
            child: Row(
              children: const [
                Icon(Icons.info_outline_rounded, color: Colors.redAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                      "Paste your stack trace below for instant analysis.",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ProCard(
              padding: EdgeInsets.zero,
              child: TextField(
                maxLines: null,
                expands: true,
                style: GoogleFonts.firaCode(fontSize: 13),
                decoration: const InputDecoration(
                  hintText:
                      "Exception: Null check operator used on a null value...",
                  filled: false,
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_fix_high_rounded),
              label: const Text("Analyze & Fix"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. CODE EXPERT SCREEN
class CodeExpertScreen extends StatelessWidget {
  const CodeExpertScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "Code Expert Terminal",
      icon: Icons.terminal_rounded,
      child: ProCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.circle, color: Colors.redAccent, size: 10),
                  SizedBox(width: 6),
                  Icon(Icons.circle, color: Colors.amber, size: 10),
                  SizedBox(width: 6),
                  Icon(Icons.circle, color: Colors.green, size: 10),
                  const Spacer(),
                  Text("gemini-pro-1.5",
                      style: GoogleFonts.firaCode(
                          color: AppColors.textSecondary, fontSize: 11))
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Ask me to explain complex logic, optimize algorithms, or refactor code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: AppColors.borderSubtle))),
              child: TextField(
                style: GoogleFonts.firaCode(color: AppColors.primaryAccent),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.primaryAccent),
                    hintText: "Enter prompt...",
                    hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. LIVE CAMERA SCREEN
class LiveCameraScreen extends StatelessWidget {
  const LiveCameraScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fake Camera View
        Container(
          color: const Color(0xFF111111),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_enhance_rounded,
                    size: 60, color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 20),
                Text("Camera Preview",
                    style: TextStyle(color: Colors.white.withOpacity(0.2)))
              ],
            ),
          ),
        ),
        // Top Safe Area
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const BackButton())),

        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: ProCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Live Vision Active",
                      style: TextStyle(
                          color: AppColors.primaryAccent,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    "Point at surroundings to hear a description.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: AppColors.primaryAccent,
                    child: const Icon(Icons.mic_rounded, color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 6. PDF SCREEN
class PDFScreen extends StatelessWidget {
  const PDFScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "PDF Intelligence",
      icon: Icons.picture_as_pdf_rounded,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProCard(
              padding: const EdgeInsets.all(40),
              child: Icon(Icons.upload_file_rounded,
                  size: 80, color: AppColors.primaryAccent.withOpacity(0.5)),
            ),
            const SizedBox(height: 30),
            const Text("Upload Documents",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text("Summarize, query, and analyze PDFs.",
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cardSurface,
                  foregroundColor: AppColors.textPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.borderSubtle))),
              icon: const Icon(Icons.add_rounded),
              label: const Text("Select PDF File"),
            ),
          ],
        ),
      ),
    );
  }
}

// 7. VOICE SCREEN
class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "Voice Assistant",
      icon: Icons.graphic_eq_rounded,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.primaryAccent.withOpacity(0.5),
                      width: 2)),
              child: const Icon(Icons.mic_rounded,
                  size: 80, color: AppColors.primaryAccent),
            ),
            const SizedBox(height: 40),
            const Text("I'm listening...",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text("Go ahead, ask me anything.",
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// 8. TEMPLATES SCREEN
class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "Content Studio",
      icon: Icons.edit_note_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select a template to generate content.",
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _toolCard("Blog Post", Icons.article_rounded, Colors.blue),
                _toolCard("Email Draft", Icons.email_rounded, Colors.orange),
                _toolCard("Social Caption", Icons.tag_rounded, Colors.pink),
                _toolCard("Code Docs", Icons.description_rounded, Colors.green),
                _toolCard(
                    "Product Desc.", Icons.shopping_bag_rounded, Colors.purple),
                _toolCard("Rewrite", Icons.refresh_rounded, Colors.cyan),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _toolCard(String title, IconData icon, Color color) {
    return ProCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24)),
          const SizedBox(height: 16),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ],
      ),
    );
  }
}

// 9. UPGRADE SCREEN
class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProPageLayout(
      title: "Upgrade Plan",
      icon: Icons.stars_rounded,
      child: Center(
        child: ProCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded,
                  size: 60, color: AppColors.primaryAccent),
              const SizedBox(height: 20),
              const Text("Go Pro",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text("Unlock the full power of Gemini.",
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 40),
              _buildFeatureRow("Gemini 1.5 Pro & Ultra Models"),
              _buildFeatureRow("Unlimited Vision & File Analysis"),
              _buildFeatureRow("Priority Processing Speed"),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Upgrade - \$19/mo",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.primaryAccent, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15))
        ],
      ),
    );
  }
}

// =============================================================================
// ✨ PROFESSIONAL UI HELPERS (The secret sauce)
// =============================================================================

// 1. ProCard: Replaces NeonWrapper with a clean, subtle border & shadow
class ProCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const ProCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

// 2. ProPageLayout: Consistent header for internal pages
class ProPageLayout extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const ProPageLayout(
      {super.key,
      required this.title,
      required this.icon,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryAccent, size: 28),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// 3. ProInput: Standardized input field
Widget _buildProInput(String hint) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderSubtle)),
    child: Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: AppColors.primaryAccent, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_upward_rounded,
              color: Colors.black, size: 20),
        )
      ],
    ),
  );
}
