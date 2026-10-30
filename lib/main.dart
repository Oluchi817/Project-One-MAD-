import 'package:flutter/material.dart';
import 'UI_screens/s1_catalog_dash.dart';
import 'UI_screens/s4_history_insights.dart';
import 'UI_screens/s5_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FestivalPocketApp());
}

class FestivalPocketApp extends StatelessWidget {
  const FestivalPocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Festival Pocket',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        // Custom palette: Orange base + soft yellow accents + bright red alerts
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8A50), // Warm accent orange
          primary: const Color(0xFFFF8A50),
          secondary: const Color(0xFFFFF176), // Soft light yellow
          error: const Color(0xFFFF1744),     // Bright red for delete/cancel alerts
          surface: Colors.white,
        ),

        // Clean white app bar with orange accent text & icons
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFFE65100),
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFE65100),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Crisp white cards with soft warm borders
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFFFF8A50).withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.orange.shade50),
          ),
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // Tabs: S1 (Marquez), S4 & S5 (Oluchi)
  final List<Widget> _screens = const [
    S1CatalogDashboardScreen(),
    S4HistoryInsightsScreen(),
    S5SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFF9C4), // Soft light yellow active pill
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.festival_outlined),
            selectedIcon: Icon(Icons.festival, color: Color(0xFFFF8A50)),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories, color: Color(0xFFFF8A50)),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune, color: Color(0xFFFF8A50)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}