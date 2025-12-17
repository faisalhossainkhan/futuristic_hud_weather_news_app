import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/weather_controller.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_constants.dart';

/// Weather Panel Widget
/// Displays current weather and forecast information
class WeatherPanel extends StatelessWidget {
  final WeatherController weatherController;
  final ColorTheme theme;

  const WeatherPanel({
    super.key,
    required this.weatherController,
    required this.theme,
  });

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 1.0,
      color: theme.primary.withValues(alpha: 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state
      if (weatherController.isLoading.value) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(40.0),
          decoration: AppTheme.getHudBoxDecoration(
            borderColor: theme.primary,
            shadowColor: theme.primary,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: theme.primary),
                const SizedBox(height: 16),
                Text(
                  'LOADING WEATHER DATA...',
                  style: AppTheme.getHudTextStyle(
                    color: theme.accent,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Error state
      final weather = weatherController.weatherData.value;
      if (weather == null) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(40.0),
          decoration: AppTheme.getHudBoxDecoration(
            borderColor: theme.alert,
            shadowColor: theme.alert,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: theme.alert, size: 48),
                const SizedBox(height: 16),
                Text(
                  'WEATHER DATA UNAVAILABLE',
                  style: AppTheme.getHudTextStyle(
                    color: theme.alert,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  weatherController.errorMessage.value,
                  style: AppTheme.getHudTextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => weatherController.retry(),
                  icon: Icon(Icons.refresh, color: theme.primary),
                  label: Text(
                    'RETRY',
                    style: TextStyle(color: theme.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Weather data display - REMOVED constraints that caused overflow
      return Container(
        padding: const EdgeInsets.all(12.0), // Reduced from 16.0
        decoration: AppTheme.getHudBoxDecoration(
          borderColor: theme.primary,
          shadowColor: theme.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.city.toUpperCase(),
                        style: AppTheme.getHudTextStyle(
                          color: theme.primary,
                          fontSize: 26.0, // Increased from 24
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2, // Increased for emphasis
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: theme.alert, size: 14), // Increased from 12
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'UPDATED: ${weatherController.timeSinceUpdate.toUpperCase()}',
                              style: AppTheme.getHudTextStyle(
                                color: theme.alert,
                                fontSize: 11, // Increased from 10
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'STATUS:',
                      style: AppTheme.getHudTextStyle(
                        color: Colors.white,
                        fontSize: 11, // Increased from 12
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      weather.status,
                      style: AppTheme.getHudTextStyle(
                        color: weather.status == 'OPTIMAL'
                            ? Colors.greenAccent
                            : theme.accent,
                        fontSize: 15, // Increased from 14
                        fontWeight: FontWeight.w700, // Increased weight
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildDivider(),

            // Current Temperature & Condition
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.thermostat, color: theme.primary, size: 40),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text.rich(
                            TextSpan(
                              style: AppTheme.getHudTextStyle(
                                color: Colors.white,
                                fontSize: 60.0,
                                fontWeight: FontWeight.w700,
                              ),
                              children: [
                                TextSpan(text: weather.temp.toString()),
                                TextSpan(
                                  text: '°C',
                                  style: AppTheme.getHudTextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      weather.forecast.isNotEmpty
                          ? weather.forecast[0].icon
                          : Icons.error,
                      color: theme.primary,
                      size: 60,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.condition.toUpperCase(),
                      style: AppTheme.getHudTextStyle(
                        color: theme.primary,
                        fontSize: 13, // Increased from 14
                        fontWeight: FontWeight.w700, // Increased weight
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            _buildDivider(),

            // Weather Details - FIXED with better constraints
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate item width: 2 items per row with spacing
                final availableWidth = constraints.maxWidth;
                final spacing = 5.0; // Reduced from 6.0
                final itemWidth = (availableWidth - spacing) / 2;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _WeatherDetail(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${weather.details.humidity}%',
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.compress,
                      label: 'Pressure',
                      value: '${weather.details.pressure} hPa',
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '${weather.details.windSpeed.toStringAsFixed(1)} m/s',
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.visibility,
                      label: 'Visibility',
                      value: '${weather.details.visibility.toStringAsFixed(1)} km',
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.thermostat_outlined,
                      label: 'Feels Like',
                      value: '${weather.details.feelsLike}°C',
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.wb_sunny,
                      label: 'Sunrise',
                      value: DateFormat('HH:mm').format(weather.details.sunrise),
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.wb_twilight,
                      label: 'Sunset',
                      value: DateFormat('HH:mm').format(weather.details.sunset),
                      theme: theme,
                      width: itemWidth,
                    ),
                    _WeatherDetail(
                      icon: Icons.eco,
                      label: 'Air Quality',
                      value: weatherController.airQuality,
                      theme: theme,
                      width: itemWidth,
                    ),
                  ],
                );
              },
            ),
            _buildDivider(),

            // Weather Advice
            Container(
              padding: const EdgeInsets.all(8.0), // Reduced from 10.0
              decoration: BoxDecoration(
                color: theme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: theme.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.accent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      weatherController.weatherAdvice.toUpperCase(),
                      style: AppTheme.getHudTextStyle(
                        color: Colors.white,
                        fontSize: 12, // Increased from 11
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Reduced from 10

            // Forecast Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '8-HR FORECAST',
                  style: AppTheme.getHudTextStyle(
                    color: theme.accent,
                    fontSize: 15, // Increased from 14
                    fontWeight: FontWeight.w700, // Increased weight
                    letterSpacing: 1.2,
                  ),
                ),
                if (weatherController.isGoodForOutdoor)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.park,
                          color: Colors.greenAccent,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'OUTDOOR',
                          style: AppTheme.getHudTextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10, // Increased from 9
                            fontWeight: FontWeight.w700, // Increased weight
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8), // Reduced from 10

            // Forecast List - FIXED: Reduced height and more compact
            SizedBox(
              height: 115, // Increased from 110 to accommodate larger text
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: weather.forecast.length,
                itemBuilder: (context, index) {
                  final forecast = weather.forecast[index];
                  return Container(
                    width: 85, // Reduced from 90
                    margin: const EdgeInsets.only(right: 6.0), // Reduced from 8.0
                    padding: const EdgeInsets.all(6.0), // Reduced from 8.0
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.primary.withValues(alpha: 0.5),
                      ),
                      color: kHudBackground.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          forecast.date,
                          style: AppTheme.getHudTextStyle(
                            color: Colors.grey,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          forecast.time,
                          style: AppTheme.getHudTextStyle(
                            color: theme.accent,
                            fontSize: 12, // Increased from 11
                            fontWeight: FontWeight.w700, // Increased weight
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3), // Reduced from 4
                        Icon(forecast.icon, color: theme.primary, size: 26), // Reduced from 28
                        const SizedBox(height: 3), // Reduced from 4
                        Text(
                          '${forecast.temp}°',
                          style: AppTheme.getHudTextStyle(
                            color: Colors.white,
                            fontSize: 15, // Reduced from 16
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: theme.alert,
                              size: 9,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${(forecast.precipitationChance * 100).toInt()}%',
                              style: AppTheme.getHudTextStyle(
                                color: theme.alert.withValues(alpha: 0.9), // Better contrast
                                fontSize: 9,
                                fontWeight: FontWeight.w600, // Added weight
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Weather Detail Widget
/// Displays a single weather metric with icon and value
class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorTheme theme;
  final double width;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.primary, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: AppTheme.getHudTextStyle(
                      color: Colors.white.withOpacity(0.6), // Better contrast
                      fontSize: 9,
                      fontWeight: FontWeight.w600, // Added weight
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    value,
                    style: AppTheme.getHudTextStyle(
                      color: Colors.white,
                      fontSize: 13, // Increased from 12
                      fontWeight: FontWeight.w700, // Increased weight
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}