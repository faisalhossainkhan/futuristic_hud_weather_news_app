import 'package:flutter/material.dart';

/// OpenWeatherMap API Key
/// Get your free API key at: https://openweathermap.org/api
const String kOpenWeatherMapApiKey = 'c86658bbe32300f5094a4a8c12c37e03';

/// NewsAPI Key
/// Get your free API key at: https://newsapi.org/register
const String kNewsApiKey = '950a2861b71a40e9a07d17ae1e6d08a1';

/// OpenRouter AI API Key
/// Get your API key at: https://openrouter.ai/
const String kOpenRouterApiKey = '';

/// Default city for weather
const String kDefaultCity = 'Dhaka';

/// Weather API base URL
const String kWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

/// News API base URL
const String kNewsBaseUrl = 'https://newsapi.org/v2';

/// OpenRouter AI API URL
const String kOpenRouterApiUrl = 'https://openrouter.ai/api/v1/chat/completions';

/// OpenRouter AI model (using Claude via OpenRouter)
const String kOpenRouterModel = 'mistralai/mistral-7b-instruct-v0.2';


/// Background color for HUD interface
const Color kHudBackground = Colors.black;

/// Placeholder image URL for news without images
const String kPlaceholderImageUrl = 'https://placehold.co/150x100/33FFFF/000000?text=NO+IMG';

/// Breakpoint for desktop/mobile layouts
const double kDesktopBreakpoint = 1000.0;

/// Default padding
const double kDefaultPadding = 16.0;

/// Small padding
const double kSmallPadding = 8.0;

/// Large padding
const double kLargePadding = 24.0;

/// Border radius
const double kBorderRadius = 12.0;

/// Small border radius
const double kSmallBorderRadius = 8.0;

/// Icon size
const double kIconSize = 24.0;

/// Small icon size
const double kSmallIconSize = 16.0;

/// Large icon size
const double kLargeIconSize = 40.0;


/// Global news sources from major international outlets
const List<NewsSource> kGlobalNewsSources = [
// General News
NewsSource(
id: 'al-jazeera-english',
name: 'Al Jazeera',
category: 'general',
language: 'en',
),
NewsSource(
id: 'bbc-news',
name: 'BBC News',
category: 'general',
language: 'en',
),
NewsSource(
id: 'cnn',
name: 'CNN',
category: 'general',
language: 'en',
),
NewsSource(
id: 'reuters',
name: 'Reuters',
category: 'general',
language: 'en',
),

// Technology News
NewsSource(
id: 'the-verge',
name: 'The Verge',
category: 'technology',
language: 'en',
),
NewsSource(
id: 'ars-technica',
name: 'Ars Technica',
category: 'technology',
language: 'en',
),
NewsSource(
id: 'techcrunch',
name: 'TechCrunch',
category: 'technology',
language: 'en',
),
NewsSource(
id: 'wired',
name: 'Wired',
category: 'technology',
language: 'en',
),

// Business News
NewsSource(
id: 'bloomberg',
name: 'Bloomberg',
category: 'business',
language: 'en',
),
NewsSource(
id: 'financial-times',
name: 'Financial Times',
category: 'business',
language: 'en',
),
NewsSource(
id: 'the-wall-street-journal',
name: 'Wall Street Journal',
category: 'business',
language: 'en',
),

// Sports News
NewsSource(
id: 'espn',
name: 'ESPN',
category: 'sports',
language: 'en',
),
NewsSource(
id: 'fox-sports',
name: 'Fox Sports',
category: 'sports',
language: 'en',
),
];

/// Sub-continent country codes (India, Pakistan, Bangladesh, Sri Lanka, Nepal)
const List<String> kSubContinentCountries = ['in', 'pk', 'bd', 'lk', 'np'];

/// Sub-continent country names
const Map<String, String> kSubContinentCountryNames = {
'in': 'India',
'pk': 'Pakistan',
'bd': 'Bangladesh',
'lk': 'Sri Lanka',
'np': 'Nepal',
};

// NEWS SOURCE MODEL

/// News source configuration model
class NewsSource {
final String id;
final String name;
final String category;
final String? language;

const NewsSource({
required this.id,
required this.name,
required this.category,
this.language,
});
}

// NEWS CATEGORIES

/// Available news categories
const List<String> kNewsCategories = [
'ALL',
'TECHNOLOGY',
'BUSINESS',
'SPORTS',
'POLITICS',
'GENERAL',
'ALERT',
];

/// Category display names
const Map<String, String> kCategoryDisplayNames = {
'ALL': 'All News',
'TECHNOLOGY': 'Technology',
'BUSINESS': 'Business',
'SPORTS': 'Sports',
'POLITICS': 'Politics',
'GENERAL': 'General',
'ALERT': 'Alerts',
};

/// Category icons
const Map<String, IconData> kCategoryIcons = {
'ALL': Icons.feed,
'TECHNOLOGY': Icons.computer,
'BUSINESS': Icons.business,
'SPORTS': Icons.sports_soccer,
'POLITICS': Icons.how_to_vote,
'GENERAL': Icons.article,
'ALERT': Icons.warning,
};

/// Color theme model
class ColorTheme {
final String name;
final Color primary;
final Color accent;
final Color alert;

const ColorTheme({
required this.name,
required this.primary,
required this.accent,
required this.alert,
});
}

/// Available app themes
final Map<String, ColorTheme> kAvailableThemes = {
'CYAN_NEO': const ColorTheme(
name: 'CYAN_NEO',
primary: Color(0xFF33FFFF),  // Bright Cyan
accent: Color(0xFFFF9900),   // Orange
alert: Color(0xFFFF5555),    // Red
),
'GREEN_MATRIX': const ColorTheme(
name: 'GREEN_MATRIX',
primary: Color(0xFF66FF33),  // Bright Green
accent: Color(0xFFFFFB00),   // Yellow
alert: Color(0xFFFF3333),    // Red
),
'MAGENTA_WAVE': const ColorTheme(
name: 'MAGENTA_WAVE',
primary: Color(0xFFFF33CC),  // Magenta
accent: Color(0xFF66FFFF),   // Cyan
alert: Color(0xFFCCFF33),    // Yellow-Green
),
};

/// Default theme key
const String kDefaultTheme = 'CYAN_NEO';

/// Available refresh intervals in minutes
const List<int> kRefreshIntervals = [1, 5, 10, 15, 30];

/// Default refresh interval (minutes)
const int kDefaultRefreshInterval = 5;


/// Temperature units
enum TemperatureUnit { celsius, fahrenheit }

/// Weather status types
const List<String> kWeatherStatus = ['OPTIMAL', 'CAUTION', 'WARNING'];

/// Number of forecast items to display
const int kForecastItemCount = 8;

/// Weather update interval (seconds)
const int kWeatherUpdateInterval = 300; // 5 minutes


/// Maximum number of news articles to fetch per request
const int kNewsPageSize = 30;

/// Maximum news articles to display in main feed
const int kMaxNewsFeedItems = 10;

/// Maximum search results to display
const int kMaxSearchResults = 20;

/// News refresh interval (seconds)
const int kNewsRefreshInterval = 600; // 10 minutes


/// Maximum chat history length
const int kMaxChatHistory = 50;

/// AI response timeout (seconds)
const int kAIResponseTimeout = 30;

/// Claude AI version
const String kClaudeVersion = '2023-06-01';

/// Maximum tokens for AI response
const int kMaxAITokens = 1024;


/// Default animation duration
const Duration kDefaultAnimationDuration = Duration(milliseconds: 300);

/// Fast animation duration
const Duration kFastAnimationDuration = Duration(milliseconds: 150);

/// Slow animation duration
const Duration kSlowAnimationDuration = Duration(milliseconds: 500);

/// Shimmer animation duration
const Duration kShimmerDuration = Duration(milliseconds: 1500);


/// Font family - Retro monospace
const String kFontFamily = 'Courier';

/// Title font size
const double kTitleFontSize = 30.0;

/// Heading font size
const double kHeadingFontSize = 20.0;

/// Subheading font size
const double kSubheadingFontSize = 18.0;

/// Body font size
const double kBodyFontSize = 14.0;

/// Small font size
const double kSmallFontSize = 12.0;

/// Tiny font size
const double kTinyFontSize = 10.0;

/// Letter spacing
const double kLetterSpacing = 0.5;

/// Title letter spacing
const double kTitleLetterSpacing = 1.5;


/// Connection timeout
const Duration kConnectionTimeout = Duration(seconds: 30);

/// Receive timeout
const Duration kReceiveTimeout = Duration(seconds: 30);

/// Maximum retry attempts
const int kMaxRetryAttempts = 3;


/// SharedPreferences keys
class StorageKeys {
// Theme
static const String themeIndex = 'theme_index';
static const String themeName = 'theme_name';

// Weather
static const String weatherLocation = 'weather_location';
static const String lastWeatherUpdate = 'last_weather_update';

// News
static const String newsCategory = 'news_category';
static const String lastNewsUpdate = 'last_news_update';
static const String bookmarkedArticles = 'bookmarked_articles';

// Settings
static const String notifications = 'notifications';
static const String autoRefresh = 'auto_refresh';
static const String refreshInterval = 'refresh_interval';

// AI
static const String chatHistory = 'chat_history';

// App
static const String firstLaunch = 'first_launch';
static const String appVersion = 'app_version';
}


/// Error messages
class ErrorMessages {
static const String networkError = 'Network connection failed';
static const String weatherUnavailable = 'Weather data unavailable';
static const String newsUnavailable = 'News feed unavailable';
static const String aiUnavailable = 'AI service temporarily unavailable';
static const String invalidApiKey = 'Invalid API key';
static const String timeout = 'Request timeout';
static const String unknownError = 'An unknown error occurred';
static const String noData = 'No data available';
static const String searchFailed = 'Search failed';
}


/// Success messages
class SuccessMessages {
static const String weatherUpdated = 'Weather data updated';
static const String newsRefreshed = 'News feed refreshed';
static const String settingsSaved = 'Settings saved successfully';
static const String themeChanged = 'Theme changed';
static const String bookmarkAdded = 'Article bookmarked';
static const String bookmarkRemoved = 'Bookmark removed';
}


/// App information
class AppInfo {
static const String appName = 'NEO-HUD System';
static const String appVersion = '2.0.0';
static const String appDescription =
'Futuristic HUD-style news and weather app with AI integration';
static const String developer = 'NEO-HUD Development Team';
static const String copyright = '© 2024 NEO-HUD Systems';
}


/// External URLs
class AppUrls {
static const String openWeatherMapApi = 'https://openweathermap.org/api';
static const String newsApi = 'https://newsapi.org';
static const String claudeApi = 'https://console.anthropic.com';
static const String privacyPolicy = 'https://example.com/privacy';
static const String termsOfService = 'https://example.com/terms';
static const String supportEmail = 'support@neohud.example.com';
}


/// Feature flags for enabling/disabling features
class FeatureFlags {
static const bool enableAI = true;
static const bool enableNotifications = true;
static const bool enableBookmarks = true;
static const bool enableSystemMonitoring = true;
static const bool enableThemeSwitching = true;
static const bool enableSearch = true;
static const bool enableAutoRefresh = true;
static const bool enableOfflineMode = false; // Future feature
}


/// Validation rules
class ValidationRules {
static const int minCityNameLength = 2;
static const int maxCityNameLength = 50;
static const int minSearchQueryLength = 2;
static const int maxSearchQueryLength = 100;
static const int minRefreshInterval = 1;
static const int maxRefreshInterval = 60;
}


/// Use mock data when API keys are not configured
const bool kUseMockWeather = false;
const bool kUseMockNews = false;
const bool kUseMockAI = true;


/// Mock weather data for testing without API key
class MockWeatherData {
static const String city = 'NEO-SEOUL SECTOR 7';
static const int temp = 14;
static const String condition = 'Cloud-Rain';
static const String status = 'OPTIMAL';
static const int humidity = 65;
static const int pressure = 1013;
static const double windSpeed = 5.5;
static const double visibility = 10.0;
static const int feelsLike = 12;
}


/// Color helper class
class HudColors {
// Opacity levels
static const double opacity10 = 0.1;
static const double opacity20 = 0.2;
static const double opacity30 = 0.3;
static const double opacity40 = 0.4;
static const double opacity50 = 0.5;
static const double opacity60 = 0.6;
static const double opacity70 = 0.7;
static const double opacity80 = 0.8;
static const double opacity90 = 0.9;

// Common colors
static const Color white = Colors.white;
static const Color grey = Colors.grey;
static const Color black = Colors.black;
static const Color transparent = Colors.transparent;

// Status colors
static const Color success = Colors.greenAccent;
static const Color warning = Colors.orangeAccent;
static const Color error = Colors.redAccent;
static const Color info = Colors.blueAccent;
}


/// Gradient configurations for HUD effects
class HudGradients {
static LinearGradient neonGlow(Color color) {
return LinearGradient(
colors: [
color.withValues(alpha:0.0),
color.withValues(alpha:0.3),
color.withValues(alpha:0.0),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
);
}

static RadialGradient glow(Color color) {
return RadialGradient(
colors: [
color.withValues(alpha:0.4),
color.withValues(alpha:0.2),
color.withValues(alpha:0.0),
],
);
}
}


/// Shadow configurations
class HudShadows {
static List<BoxShadow> neonShadow(Color color) {
return [
BoxShadow(
color: color.withValues(alpha:0.3),
blurRadius: 15.0,
spreadRadius: 2.0,
),
BoxShadow(
color: color.withValues(alpha:0.2),
blurRadius: 30.0,
spreadRadius: 5.0,
),
];
}

static List<Shadow> textGlow(Color color) {
return [
Shadow(
blurRadius: 3.0,
color: color.withValues(alpha:0.8),
),
Shadow(
blurRadius: 10.0,
color: color.withValues(alpha:0.4),
),
];
}
}


/// Supported locales
const List<Locale> kSupportedLocales = [
Locale('en', 'US'),
Locale('bn', 'BD'),
];

/// Default locale
const Locale kDefaultLocale = Locale('en', 'US');


/// Date format patterns
class DateFormats {
static const String time = 'HH:mm:ss';
static const String timeShort = 'HH:mm';
static const String date = 'MM/dd/yyyy';
static const String dateShort = 'MMM dd';
static const String dateTime = 'MM/dd/yyyy HH:mm';
static const String dateTimeFull = 'EEEE, MMMM dd, yyyy HH:mm:ss';
}


/// Debug mode flags
class DebugFlags {
static const bool enableLogging = true;
static const bool showDebugInfo = false;
static const bool mockAPIResponses = false;
static const bool skipSplashScreen = false;
}