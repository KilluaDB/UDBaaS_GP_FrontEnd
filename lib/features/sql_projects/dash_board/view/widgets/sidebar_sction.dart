import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SidebarSction extends StatelessWidget {
  
 late SettingsProvider provider;
 late    TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
     provider = Provider.of<SettingsProvider>(context);
  textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _buildInfoCard('Schema Analysis', [
          _buildInfoRow(label: 'Avg Columns/Table', value: '1.0', color: AppTheme.primary),
          _buildInfoRow(label: 'Relationship Density', value: '0.0', color: AppTheme.purple),
          _buildInfoRow(label: 'Total Relations',value:  '0', color: AppTheme.green),
        ]),
        const SizedBox(height: 24),
        _buildInfoCard('Database Overview', [
          _buildInfoRow(label: 'Database Type', value: 'SQL', isBadge: true),
          _buildInfoRow(label: 'Total Tables', value: '1'),
          _buildInfoRow(label: 'Total Columns', value: '1'),
          _buildInfoRow(label: 'Primary Keys',value:  '1'),
        ]),
            const SizedBox(height: 24),
        
        _buildInfoCard('Performance Summary', [
          _buildInfoRow(label: 'Avg Execution Time',value:  '901ms', isBadge: true),
          _buildInfoRow(label: 'Success Rate', value:  '95.8%'),
          _buildInfoRow(label: 'Slow Queries',value:  '11',color: AppTheme.orange),
          _buildInfoRow(label: 'Failed Queries',  value: '1',color: AppTheme.red),
        ]),
      ],
    );
    ;
  }

  Widget _buildInfoCard(String title, List<Widget> rows) {
    return Card(
      color: provider.isDark ? AppTheme.black : AppTheme.white,

      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium!.copyWith(fontSize: 18)
            ),
            const SizedBox(height: 16),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow( {
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
              style: textTheme.titleMedium!.copyWith(color: color)
            ),
        ],
      ),
    );
  }
}
