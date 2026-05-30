import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_metrics.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_overview_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SidebarSction extends StatelessWidget {
  final PostgresDashboardMetrics? metrics;
  final PostgresDashboardOverview? overview;

  const SidebarSction({
    super.key,
    required this.metrics,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _buildInfoCard(
          provider,
          textTheme,
          'Schema Analysis',
          [
            _buildInfoRow(
              textTheme,
              label: 'Total Tables',
              value: overview?.schemaSummary?.totalTables?.toString() ?? '-',
            ),
            _buildInfoRow(
              textTheme,
              label: 'Total Columns',
              value: overview?.schemaSummary?.totalColumns?.toString() ?? '-',
            ),
            _buildInfoRow(
              textTheme,
              label: 'Primary Keys',
              value: overview?.schemaSummary?.totalPrimaryKeys?.toString() ?? '-',
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildInfoCard(
          provider,
          textTheme,
          'Database Overview',
          [
            _buildInfoRow(
              textTheme,
              label: 'Database',
              value: overview?.db?.database ?? '-',
              isBadge: true,
            ),
        
        
            _buildInfoRow(
              textTheme,
              label: 'Ping Time',
              value: '${overview?.db?.pingTimeMs ?? 0} ms',
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildInfoCard(
          provider,
          textTheme,
          'Performance Summary',
          [
            _buildInfoRow(
              textTheme,
              label: 'DB Size',
              value: _formatBytes(metrics?.dbSizeBytes ?? 0),
              isBadge: true,
            ),
            _buildInfoRow(
              textTheme,
              label: 'Active Connections',
              value: metrics?.activeConnections?.toString() ?? '0',
            ),
            _buildInfoRow(
              textTheme,
              label: 'Idle Connections',
              value: metrics?.idleConnections?.toString() ?? '0',
            ),
            _buildInfoRow(
              textTheme,
              label: 'Cache Hit Ratio',
              value: '${((metrics?.cacheHitRatio ?? 0) * 100).toStringAsFixed(1)}%',
            ),
            _buildInfoRow(
              textTheme,
              label: 'Deadlocks',
              value: metrics?.deadlocks?.toString() ?? '0',
              color: AppTheme.orange,
            ),
            _buildInfoRow(
              textTheme,
              label: 'Blocked Sessions',
              value: metrics?.blockedSessions?.toString() ?? '0',
              color: AppTheme.red,
            ),
            _buildInfoRow(
              textTheme,
              label: 'Tables Needing Vacuum',
              value: metrics?.tablesNeedingVacuum?.toString() ?? '0',
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- CARD ----------------

  Widget _buildInfoCard(
    SettingsProvider provider,
    TextTheme textTheme,
    String title,
    List<Widget> rows,
  ) {
    return Card(
      color: provider.isDark ? AppTheme.black : AppTheme.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium!.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...rows,
          ],
        ),
      ),
    );
  }

  // ---------------- ROW ----------------

  Widget _buildInfoRow(
    TextTheme textTheme, {
    required String label,
    required String value,
    Color? color,
    bool isBadge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.titleSmall!.copyWith(color: AppTheme.boldGray),
          ),
          if (isBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            )
          else
            Text(
              value,
              style: textTheme.titleMedium!.copyWith(color: color),
            ),
        ],
      ),
    );
  }

  // ---------------- UTIL ----------------

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < sizes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(1)} ${sizes[i]}';
  }
}