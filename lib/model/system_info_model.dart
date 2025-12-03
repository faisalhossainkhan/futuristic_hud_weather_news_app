class SystemInfo {
  final String deviceModel;
  final String osVersion;
  final String platform;
  final int cores;
  final double memoryUsageMB;
  final double memoryTotalMB;
  final double cpuUsage;

  SystemInfo({
    required this.deviceModel,
    required this.osVersion,
    required this.platform,
    required this.cores,
    required this.memoryUsageMB,
    required this.memoryTotalMB,
    required this.cpuUsage,
  });

  /// Create a copy with modified fields
  SystemInfo copyWith({
    String? deviceModel,
    String? osVersion,
    String? platform,
    int? cores,
    double? memoryUsageMB,
    double? memoryTotalMB,
    double? cpuUsage,
  }) {
    return SystemInfo(
      deviceModel: deviceModel ?? this.deviceModel,
      osVersion: osVersion ?? this.osVersion,
      platform: platform ?? this.platform,
      cores: cores ?? this.cores,
      memoryUsageMB: memoryUsageMB ?? this.memoryUsageMB,
      memoryTotalMB: memoryTotalMB ?? this.memoryTotalMB,
      cpuUsage: cpuUsage ?? this.cpuUsage,
    );
  }

  /// Calculate memory usage percentage
  double get memoryUsagePercent =>
      (memoryUsageMB / memoryTotalMB * 100).clamp(0, 100);

  /// Check if system is optimal
  bool get isOptimal => cpuUsage < 80 && memoryUsagePercent < 80;

  /// Get status string
  String get status => isOptimal ? 'OPTIMAL' : 'HIGH LOAD';
}
