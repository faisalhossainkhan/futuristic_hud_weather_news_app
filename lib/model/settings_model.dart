/// App settings model
class AppSettings {
  final String weatherLocation;
  final bool notificationsEnabled;
  final bool autoRefresh;
  final int refreshInterval;
  final String preferredNewsCategory;
  final String themeName;

  AppSettings({
    required this.weatherLocation,
    required this.notificationsEnabled,
    required this.autoRefresh,
    required this.refreshInterval,
    required this.preferredNewsCategory,
    required this.themeName,
  });

  /// Create default settings
  factory AppSettings.defaults() {
    return AppSettings(
      weatherLocation: 'Dhaka',
      notificationsEnabled: true,
      autoRefresh: true,
      refreshInterval: 5,
      preferredNewsCategory: 'ALL',
      themeName: 'CYAN_NEO',
    );
  }

  /// Create a copy with modified fields
  AppSettings copyWith({
    String? weatherLocation,
    bool? notificationsEnabled,
    bool? autoRefresh,
    int? refreshInterval,
    String? preferredNewsCategory,
    String? themeName,
  }) {
    return AppSettings(
      weatherLocation: weatherLocation ?? this.weatherLocation,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoRefresh: autoRefresh ?? this.autoRefresh,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      preferredNewsCategory: preferredNewsCategory ?? this.preferredNewsCategory,
      themeName: themeName ?? this.themeName,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'weatherLocation': weatherLocation,
      'notificationsEnabled': notificationsEnabled,
      'autoRefresh': autoRefresh,
      'refreshInterval': refreshInterval,
      'preferredNewsCategory': preferredNewsCategory,
      'themeName': themeName,
    };
  }

  /// Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      weatherLocation: json['weatherLocation'] ?? 'Dhaka',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      autoRefresh: json['autoRefresh'] ?? true,
      refreshInterval: json['refreshInterval'] ?? 5,
      preferredNewsCategory: json['preferredNewsCategory'] ?? 'ALL',
      themeName: json['themeName'] ?? 'CYAN_NEO',
    );
  }
}