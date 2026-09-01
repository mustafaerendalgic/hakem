class AnalysisSummary {
  final int totalViolations;
  final int thisMonthCount;
  final String currentMonthName;
  final int resolutionRate;
  final List<LocationMetric> locationMetrics;
  final List<TypeMetric> typeMetrics;
  final List<TrendMetric> trendMetrics;
  final int investigatingCount;
  final int resolvedCount;
  final int rejectedCount;

  const AnalysisSummary({
    required this.totalViolations,
    required this.thisMonthCount,
    required this.currentMonthName,
    required this.resolutionRate,
    required this.locationMetrics,
    required this.typeMetrics,
    required this.trendMetrics,
    required this.investigatingCount,
    required this.resolvedCount,
    required this.rejectedCount,
  });

  factory AnalysisSummary.fromSupabaseJson(Map<String, dynamic> json) {
    final rawLocations = (json['location_metrics'] as List<dynamic>?) ?? [];
    final rawTypes = (json['type_metrics'] as List<dynamic>?) ?? [];
    final int total = (json['total_violations'] as num?)?.toInt() ?? 0;

    final maxLocCount = rawLocations.isNotEmpty
        ? ((rawLocations.first['count'] as num?)?.toInt() ?? 1)
        : 1;

    final locationMetrics = rawLocations.map((item) {
      final int count = (item['count'] as num?)?.toInt() ?? 0;
      return LocationMetric(
        location: (item['location'] as String?) ?? "Belirtilmemiş",
        count: count,
        percentage: maxLocCount > 0 ? (count / maxLocCount) : 0.0,
      );
    }).toList();

    final typeMetrics = rawTypes.map((item) {
      final int count = (item['count'] as num?)?.toInt() ?? 0;
      final double pct = total > 0 ? (count / total) * 100 : 0.0;
      return TypeMetric(
        title: (item['title'] as String?) ?? "Diğer",
        count: count,
        percentage: pct,
      );
    }).toList();

    return AnalysisSummary(
      totalViolations: total,
      thisMonthCount: (json['this_month_count'] as num?)?.toInt() ?? 0,
      currentMonthName: _getMonthName(DateTime.now().month),
      resolutionRate: (json['resolution_rate'] as num?)?.toInt() ?? 0,
      locationMetrics: locationMetrics,
      typeMetrics: typeMetrics,
      trendMetrics: [], 
      investigatingCount: (json['investigating_count'] as num?)?.toInt() ?? 0,
      resolvedCount: (json['resolved_count'] as num?)?.toInt() ?? 0,
      rejectedCount: (json['rejected_count'] as num?)?.toInt() ?? 0,
    );
  }

  static String _getMonthName(int month) {
    const months = [
      "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
      "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
    ];
    return months[(month - 1).clamp(0, 11)];
  }
}

class LocationMetric {
  final String location;
  final int count;
  final double percentage;

  const LocationMetric({
    required this.location,
    required this.count,
    required this.percentage,
  });
}

class TypeMetric {
  final String title;
  final int count;
  final double percentage;

  const TypeMetric({
    required this.title,
    required this.count,
    required this.percentage,
  });
}

class TrendMetric {
  final String date;
  final int count;

  const TrendMetric({
    required this.date,
    required this.count,
  });
}