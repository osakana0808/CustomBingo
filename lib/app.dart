import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/list/list_screen.dart';
import 'screens/card/card_setup_screen.dart';
import 'screens/draw/draw_screen.dart';
import 'widgets/ad_banner.dart';

// ── 和モダンカラーパレット ──────────────────────────────
class WaColors {
  static const navy      = Color(0xFF0F1629);
  static const navyCard  = Color(0xFF1A2340);
  static const navyLight = Color(0xFF243058);
  static const vermilion = Color(0xFFCC3333);
  static const vermilionDim = Color(0xFF992222);
  static const gold      = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFF0D060);
  static const cream     = Color(0xFFF5F0E8);
  static const creamDim  = Color(0xFFB0A898);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final _screens = const [
    ListScreen(),
    CardSetupScreen(),
    DrawScreen(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo Maker',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja'), Locale('en')],
      theme: _buildTheme(),
      home: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: _WaNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }

  ThemeData _buildTheme() {
    // fromSeed をベースにして各色を上書き（より安全）
    final base = ColorScheme.fromSeed(
      seedColor: WaColors.vermilion,
      brightness: Brightness.dark,
    );
    final colorScheme = base.copyWith(
      primary: WaColors.vermilion,
      onPrimary: WaColors.cream,
      primaryContainer: WaColors.vermilionDim,
      onPrimaryContainer: WaColors.cream,
      secondary: WaColors.gold,
      onSecondary: WaColors.navy,
      secondaryContainer: const Color(0xFF3A2E00),
      onSecondaryContainer: WaColors.goldLight,
      surface: WaColors.navyCard,
      onSurface: WaColors.cream,
      surfaceContainerHighest: WaColors.navyLight,
      onSurfaceVariant: WaColors.creamDim,
      outline: WaColors.gold.withValues(alpha: 0.4),
      outlineVariant: WaColors.gold.withValues(alpha: 0.2),
      error: const Color(0xFFFF6B6B),
      onError: WaColors.navy,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: WaColors.navy,

      appBarTheme: const AppBarTheme(
        backgroundColor: WaColors.navy,
        foregroundColor: WaColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: WaColors.gold,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: WaColors.creamDim),
        actionsIconTheme: IconThemeData(color: WaColors.gold),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: WaColors.navyCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0x33D4AF37), width: 1),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: WaColors.vermilion,
          foregroundColor: WaColors.cream,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: WaColors.gold),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WaColors.gold,
          side: const BorderSide(color: WaColors.gold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WaColors.navyLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: WaColors.gold.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: WaColors.gold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WaColors.gold, width: 1.5),
        ),
        labelStyle: const TextStyle(color: WaColors.creamDim),
        hintStyle: const TextStyle(color: WaColors.creamDim),
      ),

      dividerTheme: DividerThemeData(
        color: WaColors.gold.withValues(alpha: 0.2),
        thickness: 1,
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: WaColors.gold,
        textColor: WaColors.cream,
        subtitleTextStyle: TextStyle(color: WaColors.creamDim, fontSize: 12),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: WaColors.vermilion,
        foregroundColor: WaColors.cream,
        elevation: 4,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: WaColors.navyLight,
        contentTextStyle: const TextStyle(color: WaColors.cream),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: WaColors.navyCard,
        titleTextStyle: const TextStyle(
          color: WaColors.gold,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: WaColors.cream),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: WaColors.gold.withValues(alpha: 0.4)),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? WaColors.gold : WaColors.creamDim,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? WaColors.gold.withValues(alpha: 0.4)
              : WaColors.navyLight,
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: WaColors.navyLight,
          foregroundColor: WaColors.creamDim,
          selectedForegroundColor: WaColors.navy,
          selectedBackgroundColor: WaColors.gold,
          side: BorderSide(color: WaColors.gold.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0A1020),
        indicatorColor: WaColors.vermilion.withValues(alpha: 0.25),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          color: s.contains(WidgetState.selected)
              ? WaColors.gold
              : WaColors.creamDim.withValues(alpha: 0.6),
          size: 24,
        )),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
          color: s.contains(WidgetState.selected)
              ? WaColors.gold
              : WaColors.creamDim.withValues(alpha: 0.6),
          fontSize: 11,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.normal,
          letterSpacing: 0.5,
        )),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 8,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(color: WaColors.cream, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: WaColors.cream),
        titleLarge: TextStyle(color: WaColors.cream, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: WaColors.cream),
        titleSmall: TextStyle(color: WaColors.creamDim),
        bodyLarge: TextStyle(color: WaColors.cream),
        bodyMedium: TextStyle(color: WaColors.cream),
        bodySmall: TextStyle(color: WaColors.creamDim),
        labelLarge: TextStyle(color: WaColors.cream, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _WaNavigationBar extends StatelessWidget {
  const _WaNavigationBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // タブバーの下に広告を置くため、NavigationBar 自身のセーフエリア余白を
    // 取り除き、Column 全体を SafeArea で包んで最下部の余白を一括管理する
    return Container(
      color: const Color(0xFF0A1020),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    WaColors.gold.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Builder(builder: (context) {
              final l10n = AppLocalizations.of(context);
              return MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onTap,
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.format_list_bulleted),
                      selectedIcon: const Icon(Icons.format_list_bulleted),
                      label: l10n.navList,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.grid_view_outlined),
                      selectedIcon: const Icon(Icons.grid_view),
                      label: l10n.navCard,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.casino_outlined),
                      selectedIcon: const Icon(Icons.casino),
                      label: l10n.navDraw,
                    ),
                  ],
                ),
              );
            }),
            const AdBanner(),
          ],
        ),
      ),
    );
  }
}
