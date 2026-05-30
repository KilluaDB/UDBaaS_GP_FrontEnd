import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/query_history.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardCharts extends StatelessWidget {
  final List<QueryHistoryItem> queries;

  const DashboardCharts({
    super.key,
    required this.queries,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Bar Chart
        Expanded(
          flex: 1,
          child: _buildChartCard(
            title: 'Execution Time Trend',
            subtitle: 'Last 5 queries performance',
            child: BarChart(
              BarChartData(
                maxY: _getMaxY(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final titles = List.generate(
                          queries.length.clamp(0, 5),
                          (i) => 'Q${i + 1}',
                        );

                        if (value.toInt() >= titles.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            titles[value.toInt()],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          // في جزء الـ leftTitles
leftTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 40,
    interval: _getMaxY() / 4, // بيقسم الـ maxY لأربع مسافات متساوية
    getTitlesWidget: (value, meta) {
      // إظهار القيم كأرقام صحيحة
      return Text(
        '${value.toInt()}',
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
    },
  ),
),
               
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    left: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                barGroups: _getBarGroups(),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Pie Chart
        Expanded(
          flex: 1,
          child: _buildChartCard(
            title: 'Query Speed Distribution',
            subtitle: 'Fast vs Slow queries',
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    sections: _getPieSections(),
                  ),
                ),
                PositionPointer(
                  label:
                      "Fast: ${_fastQueriesCount()}",
                  color: AppTheme.green,
                  alignment: Alignment.centerLeft,
                ),
                PositionPointer(
                  label:
                      "Slow: ${_slowQueriesCount()}",
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- CARD UI ----------------

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      color: AppTheme.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.gray.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(height: 220, child: child),
          ],
        ),
      ),
    );
  }

  // ---------------- BAR CHART ----------------
List<BarChartGroupData> _getBarGroups() {
  final data = queries.take(5).map((q) => q.meanTimeMs).toList();

  while (data.length < 5) {
    data.add(0);
  }

  return List.generate(data.length, (i) {
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: data[i],
          color: const Color(0xFF3B82F6),
          width: 35,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(6),
          ),
        ),
      ],
    );
  });
}
double _getMaxY() {
  if (queries.isEmpty) return 100; // قيمة افتراضية لو مفيش داتا

  final values = queries.map((q) => q.meanTimeMs).toList();
  final maxVal = values.reduce((a, b) => a > b ? a : b);

  // لو القيم صغيرة جداً (مثلاً تحت 50ms) نخلي الـ maxY هو 100
  // لو القيم كبيرة، نخلي الـ maxY هو القيمة القصوى + 20% للراحة
  return maxVal < 100 ? 5 : (maxVal * 1.2);
}
  // ---------------- PIE CHART ----------------

List<PieChartSectionData> _getPieSections() {
  final slow = _slowQueriesCount();
  final fast = _fastQueriesCount();

  if (queries.isEmpty) {
    return [
      PieChartSectionData(
        color: Colors.grey.shade300,
        value: 1,
        showTitle: false,
        radius: 20,
      ),
    ];
  }

  return [
    PieChartSectionData(
      color: AppTheme.green,
      value: fast.toDouble(),
      showTitle: false,
      radius: 20,
    ),
    PieChartSectionData(
      color: Colors.red.shade400,
      value: slow.toDouble(),
      showTitle: false,
      radius: 20,
    ),
  ];
}
  int _slowQueriesCount() {
    return queries.where((q) => q.meanTimeMs > 1000).length;
  }

  int _fastQueriesCount() {
    return queries.where((q) => q.meanTimeMs <= 1000).length;
  }
}

// ---------------- LABEL ----------------

class PositionPointer extends StatelessWidget {
  final String label;
  final Color color;
  final Alignment alignment;

  const PositionPointer({
    super.key,
    required this.label,
    required this.color,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight)
            Container(width: 15, height: 1, color: Colors.grey.shade300),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (alignment == Alignment.centerLeft)
            Container(width: 15, height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}