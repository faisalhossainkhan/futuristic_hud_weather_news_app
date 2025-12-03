// Settings Controller
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SettingsController extends GetxController {
  final RxString weatherLocation = kDefaultCity.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool autoRefresh = true.obs;
  final RxInt refreshInterval = 5.obs; // minutes
  final RxString preferredNewsCategory = 'ALL'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    weatherLocation.value = prefs.getString('weather_location') ?? kDefaultCity;
    notificationsEnabled.value = prefs.getBool('notifications') ?? true;
    autoRefresh.value = prefs.getBool('auto_refresh') ?? true;
    refreshInterval.value = prefs.getInt('refresh_interval') ?? 5;
    preferredNewsCategory.value = prefs.getString('news_category') ?? 'ALL';
  }

  Future<void> setWeatherLocation(String location) async {
    weatherLocation.value = location;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_location', location);
  }

  Future<void> setNotifications(bool enabled) async {
    notificationsEnabled.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
  }

  Future<void> setAutoRefresh(bool enabled) async {
    autoRefresh.value = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_refresh', enabled);
  }

  Future<void> setRefreshInterval(int minutes) async {
    refreshInterval.value = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('refresh_interval', minutes);
  }

  Future<void> setNewsCategory(String category) async {
    preferredNewsCategory.value = category;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('news_category', category);
  }

  Future<void> resetToDefaults() async {
    weatherLocation.value = kDefaultCity;
    notificationsEnabled.value = true;
    autoRefresh.value = true;
    refreshInterval.value = 5;
    preferredNewsCategory.value = 'ALL';

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}