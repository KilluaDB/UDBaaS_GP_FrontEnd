import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart'
    show SettingsProvider;
import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuerySection extends StatelessWidget {

  late  TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of<SettingsProvider>(context);

    textTheme = Theme.of(context).textTheme;
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
                const Text(
                  'Query Performance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildQueryTile(
            text:   "SELECT * FROM users WHERE created_at > NOW()...",
              time: "74ms",
             color:  AppTheme.green,
            ),
            _buildQueryTile(
             text:  "INSERT INTO orders (user_id, total)...",
             time:  "1300ms",
             color:  AppTheme.orange,
              isSlow: true,
            ),
            _buildQueryTile(
           text:    "SELECT COUNT(*) FROM orders...",
              time: "640ms",
             color:  Colors.orange.shade300,
            ),
            _buildQueryTile(
             text:  "DELETE FROM sessions WHERE expires_at...",
            time:   "1777ms",
            color:   AppTheme.red,
              isSlow: true,
            ),
            const DashboardCharts(),
          ],
        ),
      ),
    );
  }
  
Widget _buildQueryTile({
  required String text,
  required Color color,
  isSlow = false,
  required String time,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.02),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.1)),
    ),
    child: Row(
      children: [
        Icon(Icons.check_circle_outline, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style:  textTheme.titleSmall!.copyWith(fontFamily: 'monospace',),
         
            overflow: TextOverflow.ellipsis,
          ),
        ),
   
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            if (isSlow)
              const Text(
                'Slow',
                style: TextStyle(color: Colors.orange, fontSize: 9),
              ),
          ],
        ),
      ],
    ),
  );
}

}
