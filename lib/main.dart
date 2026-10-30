// Root app shell & Navigation Bar - Festival Pocket
// Marquez J (S1) & Oluchi C (S4, S5)

import 'package:flutter/material.dart';
import 'UI_screens/s1_catalog_dash.dart';
import 'UI_screens/s4_history_insights.dart';
import 'UI_screens/s5_settings.dart';

void main() {
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

        // Standard Flutter colors: orange primary, yellow accent, red error
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
          secondary: Colors.yellow.shade200,
          error: Colors.redAccent,
          surface: Colors.white,
        ),

        // Clean white app bar with orange text and icons
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange.shade800,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.orange.shade800,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // White cards with light orange borders
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.orange.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.orange.shade100),
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
  final List<Widget> _screens = [
    const S1CatalogDashboardScreen(),
    const S4HistoryInsightsScreen(),
    const S5SettingsScreen(),
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
        indicatorColor: Colors.yellow.shade100, // Light yellow active indicator
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.festival_outlined),
            selectedIcon: Icon(Icons.festival, color: Colors.orange),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories, color: Colors.orange),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune, color: Colors.orange),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}