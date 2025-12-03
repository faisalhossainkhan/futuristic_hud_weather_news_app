import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_constants.dart';
import '../../model/system_info_model.dart';

/// System Monitor Widget
/// Displays real-time system performance metrics
class SystemMonitorWidget extends StatefulWidget {
  final ColorTheme theme;

  const SystemMonitorWidget({
    super.key,
    required this.theme,
  });

  @override
  State<SystemMonitorWidget> createState() => _SystemMonitorWidgetState();
}

class _SystemMonitorWidgetState extends State<SystemMonitorWidget> {
  SystemInfo? _systemInfo;
  Timer? _updateTimer;
  final _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getSystemInfo();
    _startPerformanceMonitoring();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _getSystemInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel = 'Unknown';
      String osVersion = 'Unknown';
      String platform = 'Unknown';
      int cores = 4; // Default

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
        osVersion = 'Android ${androidInfo.version.release}';
        platform = 'ANDROID';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine;
        osVersion = 'iOS ${iosInfo.systemVersion}';
        platform = 'iOS';
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        deviceModel = windowsInfo.computerName;
        osVersion = 'Windows';
        platform = 'WINDOWS';
        cores = windowsInfo.numberOfCores;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        deviceModel = linuxInfo.name;
        osVersion = 'Linux';
        platform = 'LINUX';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        deviceModel = macInfo.model;
        osVersion = 'macOS ${macInfo.osRelease}';
        platform = 'MACOS';
      }

      if (mounted) {
        setState(() {
          _systemInfo = SystemInfo(
            deviceModel: deviceModel,
            osVersion: osVersion,
            platform: platform,
            cores: cores,
            memoryUsageMB: 1024.5,
            memoryTotalMB: 8192.0,
            cpuUsage: 35.7,
          );
        });
      }
    } catch (e) {
      print('Error getting system info: $e');
    }
  }

  void _startPerformanceMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted && _systemInfo != null) {
        setState(() {
          // Simulate performance metrics (in real app, use actual system metrics)
          final time = DateTime.now().millisecondsSinceEpoch;
          _systemInfo = SystemInfo(
            deviceModel: _systemInfo!.deviceModel,
            osVersion: _systemInfo!.osVersion,
            platform: _systemInfo!.platform,
            cores: _systemInfo!.cores,
            memoryUsageMB: 800 + (time % 400).toDouble(),
            memoryTotalMB: _systemInfo!.memoryTotalMB,
            cpuUsage: 20 + (time % 60).toDouble(),
          );
        });
      }
    });
  }

  String _getUptime() {
    final duration = DateTime.now().difference(_startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_systemInfo == null) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(40.0),
        decoration: AppTheme.getHudBoxDecoration(
          borderColor: widget.theme.accent,
          shadowColor: widget.theme.accent,
        ),
        child: Center(
          child: CircularProgressIndicator(color: widget.theme.primary),
        ),
      );
    }

    final memoryPercent = (_systemInfo!.memoryUsageMB / _systemInfo!.memoryTotalMB * 100).clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: AppTheme.getHudBoxDecoration(
        borderColor: widget.theme.accent,
        shadowColor: widget.theme.accent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.theme.accent.withValues(alpha:0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.computer, color: widget.theme.accent, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SYSTEM PERFORMANCE',
                    style: AppTheme.getHudTextStyle(
                      color: widget.theme.accent,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Device Info
          _InfoRow(
            icon: Icons.phone_android,
            label: 'DEVICE',
            value: _systemInfo!.deviceModel,
            theme: widget.theme,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.computer,
            label: 'PLATFORM',
            value: '${_systemInfo!.platform} (${_systemInfo!.osVersion})',
            theme: widget.theme,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.memory,
            label: 'CPU CORES',
            value: '${_systemInfo!.cores} CORES',
            theme: widget.theme,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.access_time,
            label: 'UPTIME',
            value: _getUptime(),
            theme: widget.theme,
          ),

          const SizedBox(height: 16),
          Divider(
            color: widget.theme.accent.withValues(alpha:0.3),
            height: 1,
          ),
          const SizedBox(height: 16),

          // CPU Usage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CPU USAGE',
                style: AppTheme.getHudTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${_systemInfo!.cpuUsage.toStringAsFixed(1)}%',
                style: AppTheme.getHudTextStyle(
                  color: widget.theme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _PerformanceBar(
            percentage: _systemInfo!.cpuUsage,
            theme: widget.theme,
          ),
          const SizedBox(height: 16),

          // Memory Usage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MEMORY',
                style: AppTheme.getHudTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${_systemInfo!.memoryUsageMB.toInt()} / ${_systemInfo!.memoryTotalMB.toInt()} MB',
                style: AppTheme.getHudTextStyle(
                  color: widget.theme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _PerformanceBar(
            percentage: memoryPercent.toDouble(),
            theme: widget.theme,
          ),
          const SizedBox(height: 16),

          // Status Indicator
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: (_systemInfo!.cpuUsage < 80 ? Colors.greenAccent : widget.theme.alert).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: (_systemInfo!.cpuUsage < 80 ? Colors.greenAccent : widget.theme.alert).withValues(alpha:0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _systemInfo!.cpuUsage < 80 ? Colors.greenAccent : widget.theme.alert,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_systemInfo!.cpuUsage < 80 ? Colors.greenAccent : widget.theme.alert).withValues(alpha:0.6),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _systemInfo!.cpuUsage < 80 ? 'SYSTEM OPTIMAL' : 'HIGH LOAD',
                    style: AppTheme.getHudTextStyle(
                      color: _systemInfo!.cpuUsage < 80 ? Colors.greenAccent : widget.theme.alert,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorTheme theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: theme.primary, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTheme.getHudTextStyle(
            color: Colors.grey,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.getHudTextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  final double percentage;
  final ColorTheme theme;

  const _PerformanceBar({
    required this.percentage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPercentage = percentage.clamp(0, 100);
    final barColor = clampedPercentage < 70
        ? theme.primary
        : (clampedPercentage < 85 ? theme.accent : theme.alert);

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: kHudBackground.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: theme.primary.withValues(alpha:0.3)),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clampedPercentage / 100,
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              BoxShadow(
                color: barColor.withValues(alpha:0.5),
                blurRadius: 6.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}