import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isg_ihlal/data/cubits/analysis_cubit.dart';
import 'package:isg_ihlal/data/entity/analysis_data.dart';
import 'package:isg_ihlal/data/states/analysis_states.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beyaz,
      body: BlocBuilder<AnalysisCubit, AnalysisStates>(
        builder: (context, state) {
          if (state is AnalysisLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalysisErrorState) {
            return Center(
              child: Text(
                "Bir hata oluştu: ${state.error}",
                style: TextStyles.body,
              ),
            );
          }

          if (state is AnalysisLoadedState) {
            final summary = state.summary;
            final cubit = context.read<AnalysisCubit>();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Analiz", style: TextStyles.titlesBold),
                  const SizedBox(height: 12),

                  // Filtreleme Butonları
                  _FilterBar(
                    selectedDateFilter: state.selectedDateFilter,
                    selectedLocation: state.selectedLocation,
                    locations: summary.locationMetrics
                        .map((e) => e.location)
                        .toList(),
                    onDateChanged: (filter) => cubit.updateDateFilter(filter),
                    onLocationChanged: (loc) => cubit.updateLocationFilter(loc),
                  ),
                  const SizedBox(height: 16),

                  // 3'lü Özet Metrik Kartları
                  _SummaryMetricCards(summary: summary),
                  const SizedBox(height: 16),

                  // Lokasyon Analizi Kartı
                  _LocationAnalysisCard(metrics: summary.locationMetrics),
                  const SizedBox(height: 16),

                  // İhlal Tipi (Donut Chart) Kartı
                  _ViolationTypeChartCard(typeMetrics: summary.typeMetrics),
                  const SizedBox(height: 16),

                  // İhlal Trendi (30 Gün) Çizgi Grafiği Kartı
                  _ViolationTrendCard(trendMetrics: summary.trendMetrics),
                  const SizedBox(height: 16),

                  // Aksiyon Durumu Kartı
                  _ActionStatusCard(summary: summary),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// 1. Filtre Çubukları
// -------------------------------------------------------------
class _FilterBar extends StatelessWidget {
  final String selectedDateFilter;
  final String selectedLocation;
  final List<String> locations;
  final ValueChanged<String> onDateChanged;
  final ValueChanged<String> onLocationChanged;

  const _FilterBar({
    required this.selectedDateFilter,
    required this.selectedLocation,
    required this.locations,
    required this.onDateChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final allLocations = ["Tüm Lokasyonlar", ...locations.toSet()];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tarih Filtresi Menüsü
          PopupMenuButton<String>(
            initialValue: selectedDateFilter,
            onSelected: onDateChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "Son 30 Gün",
                child: Text("Son 30 Gün"),
              ),
              const PopupMenuItem(value: "Bu Ay", child: Text("Bu Ay")),
              const PopupMenuItem(value: "Tümü", child: Text("Tümü")),
            ],
            child: _FilterChip(
              icon: Icons.calendar_today_outlined,
              label: selectedDateFilter,
            ),
          ),
          const SizedBox(width: 8),

          // Lokasyon Filtresi Menüsü
          PopupMenuButton<String>(
            initialValue: selectedLocation,
            onSelected: onLocationChanged,
            itemBuilder: (context) => allLocations
                .map((loc) => PopupMenuItem(value: loc, child: Text(loc)))
                .toList(),
            child: _FilterChip(
              icon: Icons.location_on_outlined,
              label: selectedLocation,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.acikMavi.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mavi.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.mavi),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyles.captionBold.copyWith(color: AppColors.mavi),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: AppColors.mavi,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. Özet Metrik Kartları (Toplam, Bu Ay, Çözüm Oranı)
// -------------------------------------------------------------
class _SummaryMetricCards extends StatelessWidget {
  final AnalysisSummary summary;

  const _SummaryMetricCards({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Toplam İhlal
        Expanded(
          child: _MetricCard(
            title: "Toplam İhlal",
            value: "${summary.totalViolations}",
            valueColor: AppColors.cokTehlikeli,
            subtitleIcon: Icons.trending_up,
            subtitle:
                "${summary.totalViolations > 0 ? '+${summary.totalViolations}' : '0'}",
            subtitleColor: AppColors.tehlikeli,
          ),
        ),
        const SizedBox(width: 8),

        // Bu Ay
        Expanded(
          child: _MetricCard(
            title: "Bu Ay",
            value: "+${summary.thisMonthCount}",
            valueColor: AppColors.primary,
            subtitleIcon: Icons.calendar_today,
            subtitle: summary.currentMonthName,
            subtitleColor: AppColors.gray,
          ),
        ),
        const SizedBox(width: 8),

        // Çözüm Oranı
        Expanded(
          child: _MetricCard(
            title: "Çözüm Oranı",
            value: "%${summary.resolutionRate}",
            valueColor: AppColors.yesil,
            subtitleIcon: Icons.check_circle_outline,
            subtitle: summary.resolutionRate >= 70 ? "İyi Durum" : "Takipte",
            subtitleColor: AppColors.yesil,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final IconData subtitleIcon;
  final String subtitle;
  final Color subtitleColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitleIcon,
    required this.subtitle,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.beyaz,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kirli.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.acikGri.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.caption.copyWith(
              color: AppColors.gray,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyles.titlesBold.copyWith(
              color: valueColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(subtitleIcon, size: 12, color: subtitleColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyles.captionBold.copyWith(
                    color: subtitleColor,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. Lokasyon Analizi Kartı
// -------------------------------------------------------------
class _LocationAnalysisCard extends StatelessWidget {
  final List<LocationMetric> metrics;

  const _LocationAnalysisCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final displayMetrics = metrics.take(5).toList();

    return _AnalysisSectionCard(
      title: "Lokasyon Analizi",
      child: displayMetrics.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  "Lokasyon verisi bulunamadı",
                  style: TextStyles.caption,
                ),
              ),
            )
          : Column(
              children: displayMetrics.map((loc) {
                // Renk seçimi: Sıraya göre paletten temaya uygun renk
                final Color barColor = _getColorByIndex(
                  displayMetrics.indexOf(loc),
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loc.location,
                            style: TextStyles.smallBodySemibold,
                          ),
                          Text(
                            "${loc.count} İhlal",
                            style: TextStyles.caption.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: loc.percentage.clamp(0.05, 1.0),
                          minHeight: 8,
                          backgroundColor: AppColors.acikMavi.withValues(
                            alpha: 0.25,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Color _getColorByIndex(int index) {
    const colors = [
      AppColors.cokTehlikeli,
      AppColors.tehlikeli,
      AppColors.azTehlikeli,
      AppColors.mavi,
      AppColors.yesil,
    ];
    return colors[index % colors.length];
  }
}

// -------------------------------------------------------------
// 4. İhlal Tipi (Donut Chart) Kartı
// -------------------------------------------------------------
class _ViolationTypeChartCard extends StatelessWidget {
  final List<TypeMetric> typeMetrics;

  const _ViolationTypeChartCard({required this.typeMetrics});

  @override
  Widget build(BuildContext context) {
    final displayTypes = typeMetrics.take(4).toList();

    final List<Color> colors = [
      AppColors.cokTehlikeli,
      AppColors.azTehlikeli,
      AppColors.minRisk,
      AppColors.mavi,
    ];

    return _AnalysisSectionCard(
      title: "İhlal Tipi",
      child: displayTypes.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "İhlal tipi verisi bulunamadı",
                  style: TextStyles.caption,
                ),
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CustomPaint(
                    painter: _DonutChartPainter(
                      metrics: displayTypes,
                      colors: colors,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: displayTypes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final metric = entry.value;
                    final color = colors[index % colors.length];

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${metric.title} (%${metric.percentage.toStringAsFixed(0)})",
                          style: TextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<TypeMetric> metrics;
  final List<Color> colors;

  _DonutChartPainter({required this.metrics, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 24.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -math.pi / 2;
    double totalPercentage = metrics.fold(0.0, (sum, m) => sum + m.percentage);
    if (totalPercentage <= 0) totalPercentage = 100;

    for (int i = 0; i < metrics.length; i++) {
      final sweepAngle =
          (metrics[i].percentage / totalPercentage) * 2 * math.pi;
      paint.color = colors[i % colors.length];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// -------------------------------------------------------------
// 5. İhlal Trendi (30 Gün) Grafiği Kartı
// -------------------------------------------------------------
class _ViolationTrendCard extends StatelessWidget {
  final List<TrendMetric> trendMetrics;

  const _ViolationTrendCard({required this.trendMetrics});

  @override
  Widget build(BuildContext context) {
    return _AnalysisSectionCard(
      title: "İhlal Trendi (30 Gün)",
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrendChartPainter(metrics: trendMetrics),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: trendMetrics.isNotEmpty
                ? [
                    Text(
                      trendMetrics.first.date,
                      style: TextStyles.caption.copyWith(color: AppColors.gray),
                    ),
                    if (trendMetrics.length > 2)
                      Text(
                        trendMetrics[trendMetrics.length ~/ 2].date,
                        style: TextStyles.caption.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    Text(
                      trendMetrics.last.date,
                      style: TextStyles.caption.copyWith(color: AppColors.gray),
                    ),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<TrendMetric> metrics;

  _TrendChartPainter({required this.metrics});

  @override
  void paint(Canvas canvas, Size size) {
    if (metrics.isEmpty) return;

    final linePaint = Paint()
      ..color = AppColors.acikGri.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Kılavuz çizgileri
    canvas.drawLine(
      Offset(0, size.height * 0.2),
      Offset(size.width, size.height * 0.2),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.8),
      linePaint,
    );

    final maxCount = metrics.fold(1, (max, m) => m.count > max ? m.count : max);

    final pointPaint = Paint()
      ..color = AppColors.cokTehlikeli
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.tehlikeli.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final path = Path();
    final List<Offset> points = [];

    for (int i = 0; i < metrics.length; i++) {
      final double x =
          (i / (metrics.length - 1 == 0 ? 1 : metrics.length - 1)) * size.width;
      final double normalized = (metrics[i].count / maxCount).clamp(0.1, 0.9);
      final double y =
          size.height - (normalized * size.height * 0.7 + size.height * 0.15);

      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Trend çizgisi
    final trendLinePaint = Paint()
      ..color = AppColors.cokTehlikeli.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, trendLinePaint);

    // Noktalar
    for (final p in points) {
      canvas.drawCircle(p, 8, glowPaint);
      canvas.drawCircle(p, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// -------------------------------------------------------------
// 6. Aksiyon Durumu Kartı (İncelemede, Çözüldü, Reddedildi)
// -------------------------------------------------------------
class _ActionStatusCard extends StatelessWidget {
  final AnalysisSummary summary;

  const _ActionStatusCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return _AnalysisSectionCard(
      title: "Aksiyon Durumu",
      child: Row(
        children: [
          // İncelemede
          Expanded(
            child: _ActionStatusBox(
              count: summary.investigatingCount,
              label: "İncelemede",
              countColor: AppColors.primary,
              backgroundColor: AppColors.acikMavi.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(width: 8),

          // Çözüldü
          Expanded(
            child: _ActionStatusBox(
              count: summary.resolvedCount,
              label: "Çözüldü",
              countColor: AppColors.yesil,
              backgroundColor: AppColors.yesil.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(width: 8),

          // Reddedildi
          Expanded(
            child: _ActionStatusBox(
              count: summary.rejectedCount,
              label: "Reddedildi",
              countColor: AppColors.tehlikeli,
              backgroundColor: AppColors.tehlikeli.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionStatusBox extends StatelessWidget {
  final int count;
  final String label;
  final Color countColor;
  final Color backgroundColor;

  const _ActionStatusBox({
    required this.count,
    required this.label,
    required this.countColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: countColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyles.titlesBold.copyWith(
              color: countColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyles.captionBold.copyWith(
              color: AppColors.gray,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Genel Kart Sarmalayıcı (Section Card)
// -------------------------------------------------------------
class _AnalysisSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _AnalysisSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.beyaz,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kirli.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.acikGri.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.bodyBold.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
