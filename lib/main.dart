import 'package:flutter/material.dart';
import 'package:futuristic_hud_weather_news/views/home/settings_view.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'views/home/home_view.dart';
import 'views/ai_assistant/ai_assistant_view.dart';
import 'controllers/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize theme controller
    final themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      title: 'NEO-HUD System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(themeController.currentTheme.value),
      home: const MainAppShell(),
    ));
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final List<Widget> widgetOptions = <Widget>[
      const HomeView(),
      const AIAssistantView(),
      const SettingsView(),
    ];

    return Obx(() {
      final theme = themeController.currentTheme.value;

      return Scaffold(
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.primary.withValues(alpha:0.5),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withValues(alpha:0.3),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'HUD',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.psychology),
                label: 'AI',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Config',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: kHudBackground,
            selectedItemColor: theme.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontFamily: 'monospace'),
            type: BottomNavigationBarType.fixed,
          ),
        ),
      );
    });
  }
}