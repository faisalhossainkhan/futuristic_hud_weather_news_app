import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

// Theme Controller
class ThemeController extends GetxController {
  final Rx<ColorTheme> currentTheme = kAvailableThemes['CYAN_NEO']!.obs;
  final RxInt currentThemeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme_index') ?? 0;
    setTheme(themeIndex);
  }

  void setTheme(int index) {
    if (index >= 0 && index < kAvailableThemes.length) {
      currentThemeIndex.value = index;
      final themeKey = kAvailableThemes.keys.elementAt(index);
      currentTheme.value = kAvailableThemes[themeKey]!;
      _saveTheme(index);
    }
  }

  Future<void> _saveTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_index', index);
  }
}

