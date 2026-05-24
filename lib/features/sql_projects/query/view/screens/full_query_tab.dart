import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/query_section.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/result.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/text_to_sql_result.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/text_to_sql_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

late TextTheme textTheme;
late SettingsProvider provider;
class FullQueryTab extends StatefulWidget {
  final ProjectModel project;

  const FullQueryTab({super.key, required this.project});

  @override
  State<FullQueryTab> createState() => _FullQueryTabState();
}

class _FullQueryTabState extends State<FullQueryTab> {
  int selectedMode = 0; // 0 = SQL, 1 = AI

  @override
  Widget build(BuildContext context) {
     provider = Provider.of<SettingsProvider>(context);
     textTheme = Theme.of(context).textTheme;

    return Column(
      children: [

        // 🔘 MODE SWITCH
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: provider.isDark ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              _buildTab("SQL Query", 0),
              _buildTab("AI Assistant", 1),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // 📌 CONTENT
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedMode == 0
                ? _buildSqlMode()
                : _buildAiMode(),
          ),
        ),
      ],
    );
  }

  Widget _buildSqlMode() {
    return Column(
      children: [
        QueryPart(project: widget.project),
        SizedBox(height: 16.h),
        const ResultPart(),
      ],
    );
  }

  Widget _buildAiMode() {
    return Column(
      children: [
        TextToSqlSection(project: widget.project),
        SizedBox(height: 16.h),
        const TextToSqlResultPart(),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedMode == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedMode = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}