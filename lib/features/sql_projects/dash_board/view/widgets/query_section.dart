import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/query_history.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuerySection extends StatelessWidget {
  final List<QueryHistoryItem> queries;

  const QuerySection({super.key, required this.queries});

  @override
  Widget build(BuildContext context) {
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      color: provider.isDark ? AppTheme.black : AppTheme.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.gray.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.electric_bolt_sharp, color: AppTheme.primary),
                SizedBox(width: 12.w),
                Text('Query Performance', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            if (queries.isEmpty)
               Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text("No query history available",style: textTheme.bodySmall)),
              )
            else ...[
              ...queries.take(4).map((query) => _buildQueryTile(
                    context: context,
                    text: query.query,
                    time: "${query.meanTimeMs.toStringAsFixed(0)}ms",
                    color: _getQueryColor(query.meanTimeMs),
                    isSlow: query.meanTimeMs > 1000,
                    textTheme: textTheme,
                  )),
              const SizedBox(height: 20),
              DashboardCharts(queries: queries),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQueryTile({
    required BuildContext context,
    required String text,
    required Color color,
    required String time,
    required TextTheme textTheme,
    bool isSlow = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showFullQueryDialog(context, text),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(isSlow ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                    color: color, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(time,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFullQueryDialog(BuildContext context, String fullQuery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Full Query", style: TextStyle(fontSize: 16)),
        content: SelectableText(fullQuery, style: const TextStyle(fontFamily: 'monospace')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
        ],
      ),
    );
  }

  Color _getQueryColor(double time) {
    if (time < 200) return AppTheme.green;
    if (time < 1000) return AppTheme.orange;
    return AppTheme.red;
  }
}