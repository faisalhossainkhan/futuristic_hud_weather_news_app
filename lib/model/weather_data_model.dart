import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherData {
  final String city;
  final int temp;
  final String condition;
  final String status;
  final List<ForecastItem> forecast;
  final WeatherDetails details;

  WeatherData({
    required this.city,
    required this.temp,
    required this.condition,
    required this.status,
    required this.forecast,
    required this.details,
  });

  /// Factory constructor to create WeatherData from OpenWeatherMap API response
  factory WeatherData.fromJson(
      Map<String, dynamic> current,
      List<dynamic> forecastList,
      ) {
    final tempKelvin = current['main']['temp'];
    final mainCondition = current['weather'][0]['main'];
    final description = current['weather'][0]['description'];

    // Determine system status based on conditions
    String status = 'OPTIMAL';
    if (tempKelvin < 273.15 + 5 ||
        mainCondition.contains('Rain') ||
        mainCondition.contains('Thunderstorm')) {
      status = 'CAUTION';
    }

    // Parse forecast items (take 8 entries for 24-hour forecast)
    final forecasts = forecastList
        .take(8)
        .toList()
        .asMap()
        .entries
        .map((entry) => ForecastItem.fromJson(entry.value))
        .toList();

    // Parse detailed weather information
    final details = WeatherDetails(
      humidity: current['main']['humidity'],
      pressure: current['main']['pressure'],
      windSpeed: (current['wind']['speed'] as num).toDouble(),
      visibility: current['visibility'] / 1000, // Convert to km
      feelsLike: (current['main']['feels_like'] - 273.15).round(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        current['sys']['sunrise'] * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        current['sys']['sunset'] * 1000,
      ),
    );

    return WeatherData(
      city: current['name'] ?? 'UNKNOWN',
      temp: (tempKelvin - 273.15).round(),
      condition: description,
      status: status,
      forecast: forecasts,
      details: details,
    );
  }

  /// Create a copy with modified fields
  WeatherData copyWith({
    String? city,
    int? temp,
    String? condition,
    String? status,
    List<ForecastItem>? forecast,
    WeatherDetails? details,
  }) {
    return WeatherData(
      city: city ?? this.city,
      temp: temp ?? this.temp,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      forecast: forecast ?? this.forecast,
      details: details ?? this.details,
    );
  }
}

/// Detailed weather information (humidity, pressure, etc.)
class WeatherDetails {
  final int humidity;
  final int pressure;
  final double windSpeed;
  final double visibility;
  final int feelsLike;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherDetails({
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
  });

  /// Create a copy with modified fields
  WeatherDetails copyWith({
    int? humidity,
    int? pressure,
    double? windSpeed,
    double? visibility,
    int? feelsLike,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return WeatherDetails(
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
      visibility: visibility ?? this.visibility,
      feelsLike: feelsLike ?? this.feelsLike,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }
}

/// Individual forecast item (3-hour interval)
class ForecastItem {
  final String time;
  final String date;
  final IconData icon;
  final int temp;
  final double precipitationChance;
  final String description;

  ForecastItem({
    required this.time,
    required this.date,
    required this.icon,
    required this.temp,
    required this.precipitationChance,
    required this.description,
  });

  /// Factory constructor to create ForecastItem from API response
  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['dt_txt']);
    final iconCode = json['weather'][0]['icon'];
    final tempKelvin = json['main']['temp'];
    final pop = (json['pop'] as num?)?.toDouble() ?? 0.0;
    final description = json['weather'][0]['description'];

    return ForecastItem(
      time: DateFormat('HH:mm').format(date),
      date: DateFormat('MMM dd').format(date),
      icon: _mapWeatherIcon(iconCode),
      temp: (tempKelvin - 273.15).round(),
      precipitationChance: pop,
      description: description,
    );
  }

  /// Map OpenWeatherMap icon codes to Flutter icons
  static IconData _mapWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return Icons.wb_sunny;
      case '02d':
      case '02n':
        return Icons.cloud;
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Icons.filter_drama;
      case '09d':
      case '09n':
        return Icons.water_drop;
      case '10d':
      case '10n':
        return Icons.cloud_circle;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.blur_on;
      default:
        return Icons.error;
    }
  }

  /// Create a copy with modified fields
  ForecastItem copyWith({
    String? time,
    String? date,
    IconData? icon,
    int? temp,
    double? precipitationChance,
    String? description,
  }) {
    return ForecastItem(
      time: time ?? this.time,
      date: date ?? this.date,
      icon: icon ?? this.icon,
      temp: temp ?? this.temp,
      precipitationChance: precipitationChance ?? this.precipitationChance,
      description: description ?? this.description,
    );
  }
}
