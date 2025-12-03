import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/weather_controller.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_constants.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.put(SettingsController());
    final weatherController = Get.find<WeatherController>();

    return Obx(() {
      final theme = themeController.currentTheme.value;

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SYSTEM CONFIGURATION',
                style: AppTheme.getHudTextStyle(
                  color: theme.primary,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Theme Selection
              _SettingsSection(
                title: 'HUD VISUAL THEME',
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      'Current: ${themeController.currentTheme.value.name}',
                      style: AppTheme.getHudTextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    )),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: kAvailableThemes.entries.map((entry) {
                        final themeOption = entry.value;
                        final index = kAvailableThemes.keys.toList().indexOf(entry.key);
                        final isSelected = index == themeController.currentThemeIndex.value;

                        return SizedBox(
                          width: 120,
                          child: OutlinedButton(
                            onPressed: () => themeController.setTheme(index),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isSelected ? Colors.black : themeOption.primary,
                              backgroundColor: isSelected
                                  ? themeOption.primary
                                  : kHudBackground.withValues(alpha:0.5),
                              side: BorderSide(
                                color: isSelected
                                    ? themeOption.primary
                                    : themeOption.primary.withValues(alpha:0.5),
                                width: isSelected ? 3 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                            ),
                            child: Text(
                              themeOption.name.replaceAll('_', ' '),
                              style: TextStyle(
                                color: isSelected ? kHudBackground : themeOption.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Weather Settings
              _SettingsSection(
                title: 'WEATHER CONFIGURATION',
                theme: theme,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.location_city,
                      title: 'Location',
                      subtitle: settingsController.weatherLocation.value,
                      theme: theme,
                      onTap: () => _showLocationDialog(context, settingsController, weatherController, theme),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // App Settings
              _SettingsSection(
                title: 'APPLICATION SETTINGS',
                theme: theme,
                child: Column(
                  children: [
                    Obx(() => _SettingsSwitchTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Alert for breaking news',
                      value: settingsController.notificationsEnabled.value,
                      onChanged: settingsController.setNotifications,
                      theme: theme,
                    )),
                    Obx(() => _SettingsSwitchTile(
                      icon: Icons.refresh,
                      title: 'Auto Refresh',
                      subtitle: 'Automatic data updates',
                      value: settingsController.autoRefresh.value,
                      onChanged: settingsController.setAutoRefresh,
                      theme: theme,
                    )),
                    Obx(() => _SettingsTile(
                      icon: Icons.timer,
                      title: 'Refresh Interval',
                      subtitle: '${settingsController.refreshInterval.value} minutes',
                      theme: theme,
                      onTap: () => _showRefreshIntervalDialog(context, settingsController, theme),
                    )),
                    Obx(() => _SettingsTile(
                      icon: Icons.category,
                      title: 'News Category Filter',
                      subtitle: settingsController.preferredNewsCategory.value,
                      theme: theme,
                      onTap: () => _showCategoryDialog(context, settingsController, theme),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Management
              _SettingsSection(
                title: 'DATA MANAGEMENT',
                theme: theme,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.bookmark,
                      title: 'Bookmarked Articles',
                      subtitle: 'View saved articles',
                      theme: theme,
                      onTap: () {
                        // Navigate to bookmarks
                        Get.snackbar(
                          'BOOKMARKS',
                          'Feature coming soon',
                          backgroundColor: theme.primary.withValues(alpha:0.2),
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.restore,
                      title: 'Reset to Defaults',
                      subtitle: 'Clear all settings',
                      theme: theme,
                      trailing: Icon(Icons.warning, color: theme.alert),
                      onTap: () => _showResetDialog(context, settingsController, theme),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About
              _SettingsSection(
                title: 'ABOUT',
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEO-HUD NEWS & WEATHER SYSTEM',
                      style: AppTheme.getHudTextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 2.0.0\nBuilt with Flutter & GetX',
                      style: AppTheme.getHudTextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showLocationDialog(BuildContext context, SettingsController controller, WeatherController weatherController, ColorTheme theme) {
    final textController = TextEditingController(text: controller.weatherLocation.value);

    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        title: Text(
          'SET LOCATION',
          style: AppTheme.getHudTextStyle(color: theme.primary, fontSize: 18),
        ),
        content: TextField(
          controller: textController,
          style: AppTheme.getHudTextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Enter city name',
            hintStyle: AppTheme.getHudTextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL', style: TextStyle(color: theme.accent)),
          ),
          TextButton(
            onPressed: () {
              final location = textController.text.trim();
              if (location.isNotEmpty) {
                controller.setWeatherLocation(location);
                weatherController.changeCity(location);
                Get.back();
              }
            },
            child: Text('SET', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }

  void _showRefreshIntervalDialog(BuildContext context, SettingsController controller, ColorTheme theme) {
    final intervals = [1, 5, 10, 15, 30];

    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        title: Text(
          'REFRESH INTERVAL',
          style: AppTheme.getHudTextStyle(color: theme.primary, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: intervals.map((interval) {
            return ListTile(
              title: Text(
                '$interval minutes',
                style: AppTheme.getHudTextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: controller.refreshInterval.value == interval
                  ? Icon(Icons.check, color: theme.primary)
                  : null,
              onTap: () {
                controller.setRefreshInterval(interval);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, SettingsController controller, ColorTheme theme) {
    final categories = ['ALL', 'TECHNOLOGY', 'BUSINESS', 'SPORTS', 'POLITICS', 'GENERAL'];

    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        title: Text(
          'NEWS CATEGORY',
          style: AppTheme.getHudTextStyle(color: theme.primary, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((category) {
            return ListTile(
              title: Text(
                category,
                style: AppTheme.getHudTextStyle(color: Colors.white, fontSize: 14),
              ),
              trailing: controller.preferredNewsCategory.value == category
                  ? Icon(Icons.check, color: theme.primary)
                  : null,
              onTap: () {
                controller.setNewsCategory(category);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsController controller, ColorTheme theme) {
    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        title: Text(
          'RESET SETTINGS?',
          style: AppTheme.getHudTextStyle(color: theme.alert, fontSize: 18),
        ),
        content: Text(
          'This will reset all settings to default values.',
          style: AppTheme.getHudTextStyle(color: Colors.white, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL', style: TextStyle(color: theme.accent)),
          ),
          TextButton(
            onPressed: () {
              controller.resetToDefaults();
              Get.back();
              Get.snackbar(
                'RESET COMPLETE',
                'Settings restored to defaults',
                backgroundColor: theme.primary.withValues(alpha:0.2),
                colorText: Colors.white,
              );
            },
            child: Text('RESET', style: TextStyle(color: theme.alert)),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final ColorTheme theme;
  final Widget child;

  const _SettingsSection({
    required this.title,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: AppTheme.getHudBoxDecoration(
        borderColor: theme.primary,
        shadowColor: theme.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.getHudTextStyle(
              color: theme.accent,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorTheme theme;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.theme,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: theme.primary),
      title: Text(
        title.toUpperCase(),
        style: AppTheme.getHudTextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle.toUpperCase(),
        style: AppTheme.getHudTextStyle(
          color: theme.accent.withValues(alpha:0.7),
          fontSize: 12,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: theme.primary),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;
  final ColorTheme theme;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: theme.primary),
      title: Text(
        title.toUpperCase(),
        style: AppTheme.getHudTextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle.toUpperCase(),
        style: AppTheme.getHudTextStyle(
          color: theme.accent.withValues(alpha:0.7),
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.primary,
    );
  }
}