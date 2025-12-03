import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../model/weather_data_model.dart';

/// Weather Controller
/// Manages weather data fetching, caching, and state management
class WeatherController extends GetxController {

  /// Current weather data
  final Rx<WeatherData?> weatherData = Rx<WeatherData?>(null);

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Error message
  final RxString errorMessage = ''.obs;

  /// Current city
  final RxString currentCity = kDefaultCity.obs;

  /// Last update timestamp
  final Rx<DateTime?> lastUpdate = Rx<DateTime?>(null);

  /// Auto-refresh enabled
  final RxBool autoRefreshEnabled = true.obs;


  Timer? _refreshTimer;
  int _retryCount = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeWeather();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  /// Initialize weather data on startup
  Future<void> _initializeWeather() async {
    await fetchWeather();
    _startAutoRefresh();
  }

  /// Start auto-refresh timer
  void _startAutoRefresh() {
    if (!FeatureFlags.enableAutoRefresh) return;

    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      Duration(seconds: kWeatherUpdateInterval),
          (_) {
        if (autoRefreshEnabled.value) {
          refreshWeather(silent: true);
        }
      },
    );
  }

  /// Fetch weather data for the current or specified city
  Future<void> fetchWeather({String? city, bool silent = false}) async {
    try {
      if (!silent) {
        isLoading.value = true;
        errorMessage.value = '';
      }

      final cityToFetch = city ?? currentCity.value;

      // Validate city name
      if (!_isValidCityName(cityToFetch)) {
        throw Exception('Invalid city name');
      }

      // Check if we should use mock data
      if (kUseMockWeather || kOpenWeatherMapApiKey == 'YOUR_OPENWEATHER_API_KEY') {
        await _loadMockWeather();
        return;
      }

      // Fetch current weather
      final currentWeather = await _fetchCurrentWeather(cityToFetch);

      // Fetch forecast
      final forecast = await _fetchForecast(cityToFetch);

      // Parse and set weather data
      weatherData.value = WeatherData.fromJson(currentWeather, forecast);
      currentCity.value = cityToFetch;
      lastUpdate.value = DateTime.now();
      _retryCount = 0;

      // Show success message if not silent
      if (!silent) {
        Get.snackbar(
          'Success',
          SuccessMessages.weatherUpdated,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

    } catch (e) {
      _handleError(e, silent);
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  /// Fetch current weather from API
  Future<Map<String, dynamic>> _fetchCurrentWeather(String city) async {
    try {
      final uri = Uri.parse(
          '$kWeatherBaseUrl/weather?q=$city&appid=$kOpenWeatherMapApiKey'
      );

      final response = await http.get(uri).timeout(
        kConnectionTimeout,
        onTimeout: () => throw TimeoutException(ErrorMessages.timeout),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else if (response.statusCode == 401) {
        throw Exception(ErrorMessages.invalidApiKey);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch forecast from API
  Future<List<dynamic>> _fetchForecast(String city) async {
    try {
      final uri = Uri.parse(
          '$kWeatherBaseUrl/forecast?q=$city&appid=$kOpenWeatherMapApiKey'
      );

      final response = await http.get(uri).timeout(
        kConnectionTimeout,
        onTimeout: () => throw TimeoutException(ErrorMessages.timeout),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['list'] as List;
      } else {
        throw Exception('Failed to load forecast');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Load mock weather data for testing
  Future<void> _loadMockWeather() async {
    await Future.delayed(const Duration(seconds: 1));

    // Create mock forecast items
    final mockForecast = List.generate(8, (index) {
      final time = DateTime.now().add(Duration(hours: index * 3));
      return ForecastItem(
        time: '${time.hour.toString().padLeft(2, '0')}:00',
        date: '${time.month}/${time.day}',
        icon: _getMockWeatherIcon(index),
        temp: MockWeatherData.temp + (index % 3) - 1,
        precipitationChance: (index % 5) * 0.2,
        description: _getMockWeatherDescription(index),
      );
    });

    // Create mock weather details
    final mockDetails = WeatherDetails(
      humidity: MockWeatherData.humidity,
      pressure: MockWeatherData.pressure,
      windSpeed: MockWeatherData.windSpeed,
      visibility: MockWeatherData.visibility,
      feelsLike: MockWeatherData.feelsLike,
      sunrise: DateTime.now().subtract(const Duration(hours: 2)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
    );

    weatherData.value = WeatherData(
      city: MockWeatherData.city,
      temp: MockWeatherData.temp,
      condition: MockWeatherData.condition,
      status: MockWeatherData.status,
      forecast: mockForecast,
      details: mockDetails,
    );

    lastUpdate.value = DateTime.now();
  }


  /// Refresh weather data
  Future<void> refreshWeather({bool silent = false}) async {
    return fetchWeather(silent: silent);
  }

  /// Change city and fetch weather
  Future<void> changeCity(String city) async {
    if (city.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a city name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    currentCity.value = city.trim();
    await fetchWeather(city: city.trim());
  }

  /// Toggle auto-refresh
  void toggleAutoRefresh(bool enabled) {
    autoRefreshEnabled.value = enabled;
    if (enabled) {
      _startAutoRefresh();
    } else {
      _refreshTimer?.cancel();
    }
  }

  /// Retry failed request
  Future<void> retry() async {
    if (_retryCount < kMaxRetryAttempts) {
      _retryCount++;
      await fetchWeather();
    } else {
      Get.snackbar(
        'Error',
        'Maximum retry attempts reached',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }


  /// Check if data is stale (older than refresh interval)
  bool get isDataStale {
    if (lastUpdate.value == null) return true;
    final now = DateTime.now();
    final difference = now.difference(lastUpdate.value!);
    return difference.inSeconds > kWeatherUpdateInterval;
  }

  /// Get time since last update
  String get timeSinceUpdate {
    if (lastUpdate.value == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastUpdate.value!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  /// Check if weather data is available
  bool get hasWeatherData => weatherData.value != null;

  /// Get current temperature
  int get currentTemp => weatherData.value?.temp ?? 0;

  /// Get current condition
  String get currentCondition => weatherData.value?.condition ?? 'Unknown';

  /// Get weather status
  String get weatherStatus => weatherData.value?.status ?? 'UNKNOWN';


  /// Validate city name
  bool _isValidCityName(String city) {
    final trimmed = city.trim();
    return trimmed.length >= ValidationRules.minCityNameLength &&
        trimmed.length <= ValidationRules.maxCityNameLength &&
        RegExp(r'^[a-zA-Z\s-]+$').hasMatch(trimmed);
  }

  /// Handle errors
  void _handleError(dynamic error, bool silent) {
    String message = ErrorMessages.weatherUnavailable;

    if (error is TimeoutException) {
      message = ErrorMessages.timeout;
    } else if (error.toString().contains('City not found')) {
      message = 'City not found. Please check the name.';
    } else if (error.toString().contains('Invalid API key')) {
      message = ErrorMessages.invalidApiKey;
    } else if (error.toString().contains('Invalid city name')) {
      message = 'Please enter a valid city name';
    } else if (error.toString().contains('SocketException')) {
      message = ErrorMessages.networkError;
    }

    errorMessage.value = message;

    // Show error snackbar if not silent
    if (!silent) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withValues(alpha:0.1),
        duration: const Duration(seconds: 3),
      );
    }

    // Try to load mock data as fallback
    if (!kUseMockWeather && _retryCount == 0) {
      _loadMockWeather();
    }

    print('Weather API Error: $error');
  }

  /// Get mock weather icon based on index
  IconData _getMockWeatherIcon(int index) {
    final icons = [
      Icons.wb_sunny,
      Icons.cloud,
      Icons.filter_drama,
      Icons.cloud_circle,
      Icons.flash_on,
      Icons.water_drop,
      Icons.ac_unit,
      Icons.blur_on,
    ];
    return icons[index % icons.length];
  }

  /// Get mock weather description
  String _getMockWeatherDescription(int index) {
    final descriptions = [
      'clear sky',
      'few clouds',
      'scattered clouds',
      'broken clouds',
      'shower rain',
      'rain',
      'thunderstorm',
      'snow',
      'mist',
    ];
    return descriptions[index % descriptions.length];
  }


  /// Convert Celsius to Fahrenheit
  static int celsiusToFahrenheit(int celsius) {
    return (celsius * 9 / 5 + 32).round();
  }

  /// Convert Fahrenheit to Celsius
  static int fahrenheitToCelsius(int fahrenheit) {
    return ((fahrenheit - 32) * 5 / 9).round();
  }

  /// Format temperature with unit
  String formatTemperature(int temp, {TemperatureUnit unit = TemperatureUnit.celsius}) {
    if (unit == TemperatureUnit.fahrenheit) {
      return '${celsiusToFahrenheit(temp)}°F';
    }
    return '$temp°C';
  }


  /// Get weather advice based on current conditions
  String get weatherAdvice {
    final weather = weatherData.value;
    if (weather == null) return 'No weather data available';

    final temp = weather.temp;
    final condition = weather.condition.toLowerCase();
    final humidity = weather.details.humidity;

    if (temp < 0) {
      return 'Freezing temperature. Dress warmly!';
    } else if (temp < 10) {
      return 'Cold weather. Wear warm clothing.';
    } else if (temp > 35) {
      return 'Very hot! Stay hydrated and avoid sun exposure.';
    } else if (temp > 30) {
      return 'Hot weather. Drink plenty of water.';
    } else if (condition.contains('rain')) {
      return 'Rainy conditions. Carry an umbrella.';
    } else if (condition.contains('storm')) {
      return 'Stormy weather. Stay indoors if possible.';
    } else if (condition.contains('snow')) {
      return 'Snowy conditions. Drive carefully.';
    } else if (humidity > 80) {
      return 'High humidity. May feel uncomfortable.';
    } else {
      return 'Pleasant weather conditions.';
    }
  }

  /// Check if it's a good day for outdoor activities
  bool get isGoodForOutdoor {
    final weather = weatherData.value;
    if (weather == null) return false;

    final temp = weather.temp;
    final condition = weather.condition.toLowerCase();

    return temp > 15 &&
        temp < 30 &&
        !condition.contains('rain') &&
        !condition.contains('storm');
  }

  /// Get air quality index (simplified based on available data)
  String get airQuality {
    final weather = weatherData.value;
    if (weather == null) return 'Unknown';

    final visibility = weather.details.visibility;

    if (visibility > 10) {
      return 'Excellent';
    } else if (visibility > 5) {
      return 'Good';
    } else if (visibility > 2) {
      return 'Moderate';
    } else {
      return 'Poor';
    }
  }
}