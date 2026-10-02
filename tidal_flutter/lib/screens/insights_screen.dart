import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../theme.dart';

/// The "Insights" tab (MVP): average cycle and period length, plus a bar
/// chart of the most recent cycles. Each bar is one cycle: its height is
/// the cycle length, with the period days shaded rose at the bottom, and a
/// dashed line marks the average. Cycles left out of the average (shorter
/// than 18 or longer than 45 days) are drawn faded and labelled "53*".
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  CycleSummary? _summary;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final summary = await client.insight.getCycleSummary();
      if (mounted) {
        setState(() {
          _summary = summary;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (_error != null)
              Text(
                'Could not load insights: $_error',
                style: const TextStyle(color: TidalColors.rose),
              )
            else if (summary == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Avg cycle',
                      value: '${summary.averageCycleDays} days',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Avg period',
                      value: '${summary.averagePeriodDays} days',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Recent cycles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (summary.cycles.isEmpty)
                Text(
                  'Your cycles will show here once you have logged at least '
                  'two periods. Long-press a day on the Calendar to start one.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else ...[
                SizedBox(height: 260, child: _CycleChart(summary: summary)),
                const SizedBox(height: 12),
                const _ChartLegend(),
                if (summary.cycles.any((c) => c.excludedFromAverage)) ...[
                  const SizedBox(height: 8),
                  Text(
                    '* Unusual length: recorded, not counted in the average',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// One big number with a label, e.g. "Avg cycle · 26 days".
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TidalColors.card,
        borderRadius: BorderRadius.circular(TidalRadius.large),
        border: Border.all(color: TidalColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: TidalColors.lavender),
          ),
        ],
      ),
    );
  }
}

/// The bar chart: one stacked bar per cycle (period days in rose, the rest
/// in lavender), the cycle length above each bar, the cycle's start date
/// below it, and a dashed line at the average cycle length.
class _CycleChart extends StatelessWidget {
  final CycleSummary summary;
  const _CycleChart({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cycles = summary.cycles;
    final average = summary.averageCycleDays;
    final tallest = cycles.map((c) => c.days).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: (tallest + 8).toDouble(),
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var i = 0; i < cycles.length; i++)
            BarChartGroupData(x: i, barRods: [_rod(cycles[i])]),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: average.toDouble(),
              color: TidalColors.lavender,
              strokeWidth: 1.5,
              dashArray: [6, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: const TextStyle(
                  color: TidalColors.lavender,
                  fontSize: 12,
                ),
                labelResolver: (_) => 'avg $average',
              ),
            ),
          ],
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final cycle = cycles[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    cycle.excludedFromAverage
                        ? '${cycle.days}*'
                        : '${cycle.days}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: TidalColors.text,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final start = cycles[value.toInt()].startDate;
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    formatDayLabel(start).split(' ').skip(1).join(' '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  BarChartRodData _rod(CycleLength cycle) {
    // Cycles left out of the average are drawn faded.
    final alpha = cycle.excludedFromAverage ? 0.35 : 1.0;
    final period = cycle.periodDays.clamp(0, cycle.days).toDouble();
    return BarChartRodData(
      toY: cycle.days.toDouble(),
      width: 26,
      borderRadius: BorderRadius.circular(8),
      rodStackItems: [
        BarChartRodStackItem(
          0,
          period,
          TidalColors.rose.withValues(alpha: alpha),
        ),
        BarChartRodStackItem(
          period,
          cycle.days.toDouble(),
          TidalColors.lavenderRing.withValues(alpha: alpha),
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();

  @override
  Widget build(BuildContext context) {
    Widget item(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        item(TidalColors.rose, 'Period days'),
        item(TidalColors.lavenderRing, 'Rest of cycle'),
      ],
    );
  }
}
