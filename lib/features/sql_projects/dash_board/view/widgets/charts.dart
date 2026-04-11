import 'package:dbaas_project/core/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
     
        Expanded(
          flex: 1,
          child: _buildChartCard(
            title: 'Execution Time Trend',
            subtitle: 'Last 5 queries performance',
            child: BarChart(
              BarChartData(
                maxY: 1200, 
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashArray: [5, 5]
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Q1', 'Q2', 'Q3', 'Q4', 'Q5'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(titles[value.toInt()],
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value % 300 == 0) { // إظهار قيم 0, 300, 600, 900, 1200
                          return Text('${value.toInt()}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12));
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                    left: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                  ),
                ),
                barGroups: _getBarGroups(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // 2. Query Status Distribution (Donut Chart)
        Expanded(
          flex: 1,
          child: _buildChartCard(
            title: 'Query Status Distribution',
            subtitle: 'Success vs Failed queries',
            child: Stack( // عشان نعمل الـ Labels اللي في الجنب زي الصورة
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60, // فراغ أكبر في النص عشان تبقى Donut
                    sections: _getPieSections(),
                  ),
                ),
                // إضافة نصوص التوضيح (Success: 23, Failed: 1)
                PositionPointer(label: "Success: 23", color: AppTheme.green, alignment: Alignment.centerLeft),
                PositionPointer(label: "Failed: 1", color: Colors.red, alignment: Alignment.centerRight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard({required String title, required String subtitle, required Widget child}) {
    return Card(
      color: AppTheme.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // حواف أنعم شوية
        side: BorderSide(color: AppTheme.gray.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const SizedBox(height: 30),
            SizedBox(height: 220, child: child),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    // القيم التقريبية من الصورة
    final data = [500.0, 600.0, 320.0, 80.0, 1150.0];
    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            color: const Color(0xFF3B82F6), // اللون الأزرق الموجود في الصورة
            width: 35, // عرض العمود
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _getPieSections() {
    return [
      PieChartSectionData(
        color: AppTheme.green, // اللون الأخضر للـ Success
        value: 23,
        showTitle: false, // لا نريد أرقام داخل الرسمة
        radius: 20,
      ),
      PieChartSectionData(
        color: Colors.red.shade400, // اللون الأحمر للـ Failed
        value: 1,
        showTitle: false,
        radius: 20,
      ),
    ];
  }
}

class PositionPointer extends StatelessWidget {
  final String label;
  final Color color;
  final Alignment alignment;

  const PositionPointer({super.key, required this.label, required this.color, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight) Container(width: 15, height: 1, color: Colors.grey.shade300),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          if (alignment == Alignment.centerLeft) Container(width: 15, height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}