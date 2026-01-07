// lib/app.dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';
import 'screens/community_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/ngo_dashboard_screen.dart';
import 'screens/ngo_report_management_screen.dart';
import 'screens/inventory_management_screen.dart';
import 'screens/location_calibration_screen.dart';
import 'screens/post_updates_screen.dart';
import 'screens/ai_chatbot_screen.dart';
import 'screens/hotline_screen.dart';
import 'screens/settings_screen.dart';
import 'services/mock_data_service.dart';
import 'widgets/expandable_bottom_nav.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Response System',
      theme: AppTheme.light(),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String _currentRoute = '';

  @override
  void initState() {
    super.initState();
    _setInitialRoute();
  }

  void _setInitialRoute() {
    final role = MockDataService.currentRole;
    if (role.isEmpty) {
      _currentRoute = 'login';
    } else if (role == 'NGO') {
      _currentRoute = 'ngo_dashboard';
    } else {
      _currentRoute = 'home';
    }
  }

  void _onNavigate(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentRoute) {
      case 'login':
        return LoginScreen(onLogin: () {
          setState(() {
            final role = MockDataService.currentRole;
            _currentRoute = role == 'NGO' ? 'ngo_dashboard' : 'home';
          });
        });
      
      // Citizen screens
      case 'home':
        return const HomeScreen();
      case 'report':
        return const ReportScreen();
      case 'map':
        return const MapScreen();
      case 'chatbot':
        return const AIChatbotScreen();
      case 'location':
        return const LocationCalibrationScreen();
      case 'hotline':
        return const HotlineScreen();
      case 'settings':
        return const SettingsScreen();
      case 'profile':
        return const ProfileScreen();
      
      // NGO screens
      case 'ngo_dashboard':
        return const NGODashboardScreen();
      case 'manage_reports':
        return const NGOReportManagementScreen();
      case 'inventory':
        return const InventoryManagementScreen();
      case 'post_updates':
        return const PostUpdatesScreen();
      case 'community':
        return const CommunityScreen();
      case 'heatmaps':
        return const MapScreen(); // Placeholder for heatmaps
      
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show login screen without navigation if no role selected
    if (MockDataService.currentRole.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: _getCurrentScreen(),
      );
    }

    // Main app with expandable bottom navigation
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Main content with bottom padding
          Positioned.fill(
            bottom: 65,
            child: _getCurrentScreen(),
          ),
          // Bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ExpandableBottomNav(
              onNavigate: _onNavigate,
              currentRoute: _currentRoute,
            ),
          ),
        ],
      ),
    );
  }
}
