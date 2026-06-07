import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view_model/mongo_dashboard_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view_model/mongo_dashboard_states.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/data/models/dashboard_model.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';



class MongoDashboardFullScreen extends StatefulWidget {
  final ProjectModel project;

  const MongoDashboardFullScreen({
    super.key,
    required this.project,
  });

  @override
  State<MongoDashboardFullScreen> createState() =>
      _MongoDashboardFullScreenState();
}

class _MongoDashboardFullScreenState extends State<MongoDashboardFullScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<MongoDashboardCubit>();
    cubit.getDashboardMetrics(widget.project.id);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<MongoDashboardCubit, MongoDashboardStates>(
      builder: (context, state) {
        final cubit = context.read<MongoDashboardCubit>();
        final metrics = cubit.metrics;

        if (state is GetMongoDashboardMetricsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetMongoDashboardMetricsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (metrics == null) {
          return const Center(child: Text("No data available"));
        }

        final topCards = _buildTopCards(metrics);
        final bottomCards = _buildBottomCards(metrics);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MongoDB Dashboard",
                style: textTheme.headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Overview of your database health and usage",
                style: textTheme.titleSmall!
                    .copyWith(color: AppTheme.gray),
              ),

              const SizedBox(height: 32),

           
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topCards.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) => topCards[index],
              ),

              const SizedBox(height: 24),

           
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bottomCards.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) => bottomCards[index],
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

 

  List<Widget> _buildTopCards(MongoDashboardMetrics m) => [
        CardWidget(
          title: "Database",
          value: m.database,
          description: "Instance name",
          icon: Icons.storage,
          color: AppTheme.primary,
        ),
        CardWidget(
          title: "Collections",
          value: "${m.collections}",
          description: "Total collections",
          icon: Icons.folder,
          color: AppTheme.purple,
        ),
        CardWidget(
          title: "Documents",
          value: "${m.totalDocuments}",
          description: "Total records",
          icon: Icons.insert_drive_file,
          color: AppTheme.orange,
        ),
        CardWidget(
          title: "DB Size",
          value: _formatBytes(m.dbSizeBytes),
          description: "Storage usage",
          icon: Icons.data_usage,
          color: AppTheme.green,
        ),
      ];


  List<Widget> _buildBottomCards(MongoDashboardMetrics m) => [
        CardWidget(
          title: "Inserts (30d)",
          value: "${m.last30Days.inserts}",
          description: "New documents",
          icon: Icons.add,
          color: AppTheme.green,
        ),
        CardWidget(
          title: "Updates (30d)",
          value: "${m.last30Days.updates}",
          description: "Modified documents",
          icon: Icons.update,
          color: AppTheme.orange,
        ),
        CardWidget(
          title: "Deletes (30d)",
          value: "${m.last30Days.deletes}",
          description: "Removed documents",
          icon: Icons.delete,
          color: AppTheme.red,
        ),
      ];


  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];

    int i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < sizes.length - 1) {
      size /= 1024;
      i++;
    }

    return "${size.toStringAsFixed(1)} ${sizes[i]}";
  }
}