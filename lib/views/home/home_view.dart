import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/weather_controller.dart';
import '../../controllers/news_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../constants/app_constants.dart';
import '../widgets/weather_panel.dart';
import '../widgets/news_feed_widget.dart';
import '../widgets/status_bar.dart';
import '../widgets/system_monitor_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.put(WeatherController());
    final newsController = Get.put(NewsController());
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final theme = themeController.currentTheme.value;

      return RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            weatherController.refreshWeather(),
            newsController.refreshAllNews(),
          ]);
        },
        color: theme.primary,
        backgroundColor: kHudBackground,
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar (Fixed height)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: StreamBuilder<DateTime>(
                  stream: Stream.periodic(
                    const Duration(seconds: 1),
                        (_) => DateTime.now(),
                  ),
                  builder: (context, snapshot) {
                    final currentTime = snapshot.data ?? DateTime.now();
                    return StatusBar(
                      weatherTemp: weatherController.weatherData.value?.temp ?? 0,
                      currentTime: currentTime,
                      theme: theme,
                    );
                  },
                ),
              ),

              // Main Content (Flexible - takes remaining space)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > kDesktopBreakpoint;

                    if (isDesktop) {
                      return _DesktopLayout(
                        weatherController: weatherController,
                        newsController: newsController,
                        theme: theme,
                      );
                    } else {
                      return _MobileLayout(
                        weatherController: weatherController,
                        newsController: newsController,
                        theme: theme,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DesktopLayout extends StatelessWidget {
  final WeatherController weatherController;
  final NewsController newsController;
  final ColorTheme theme;

  const _DesktopLayout({
    required this.weatherController,
    required this.newsController,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column (Weather + System Monitor)
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                WeatherPanel(
                  weatherController: weatherController,
                  theme: theme,
                ),
                const SizedBox(height: 16),
                SystemMonitorWidget(theme: theme),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right column (Global news)
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                NewsFeedWidget(
                  title: 'GLOBAL NEWS',
                  newsController: newsController,
                  newsType: NewsType.global,
                  theme: theme,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final WeatherController weatherController;
  final NewsController newsController;
  final ColorTheme theme;

  const _MobileLayout({
    required this.weatherController,
    required this.newsController,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        WeatherPanel(
          weatherController: weatherController,
          theme: theme,
        ),
        const SizedBox(height: 16),
        NewsFeedWidget(
          title: 'GLOBAL NEWS',
          newsController: newsController,
          newsType: NewsType.global,
          theme: theme,
        ),
        const SizedBox(height: 16),
        SystemMonitorWidget(theme: theme),
        const SizedBox(height: 16),
      ],
    );
  }
}