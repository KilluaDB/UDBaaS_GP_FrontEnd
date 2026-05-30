import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/state_card.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/query_section.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/sidebar_sction.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view_model/dash_cubit.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view_model/dash_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/card_widget.dart';

class DashboardFullScreen extends StatefulWidget {
  final ProjectModel project;
  const DashboardFullScreen({super.key, required this.project});

  @override
  State<DashboardFullScreen> createState() => _DashboardFullScreenState();
}

class _DashboardFullScreenState extends State<DashboardFullScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<DashCubit>();
    cubit.getDashboardOverview(widget.project.id);
    cubit.getDashboardMetrics(widget.project.id);
    cubit.getQueryHistory(widget.project.id);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<DashCubit, DashStates>(
      builder: (context, state) {
        final cubit = context.read<DashCubit>();
        
        var overview = cubit.overview;
        var metrics = cubit.metrics;
        var queries = cubit.queryHistory;

        if (state is GetDashboardOverviewSuccess) overview = state.postgresDashboardOverview;
        if (state is GetDashboardMetricsSuccess) metrics = state.postgresDashboardMetrics;
        if (state is GetQueryHistorySuccess) queries = state.queryHistory;

        if (state is GetDashboardOverviewLoading ||
            state is GetDashboardMetricsLoading ||
            state is GetQueryHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetDashboardOverviewError ||
            state is GetDashboardMetricsError ||
            state is GetQueryHistoryError) {
          final message = (state as dynamic).message;
          return Center(child: Text(message, style: const TextStyle(color: Colors.red)));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isTablet = constraints.maxWidth < 1024 && !isMobile;

            final topCards = _buildTopCards(overview);
            final bottomCards = _buildBottomCards(metrics);

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                  Text('Monitor your database performance and metrics', style: textTheme.titleSmall!.copyWith(color: AppTheme.gray)),
                  const SizedBox(height: 32),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topCards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                      childAspectRatio: isMobile ? 2.5 : 304 / 164,
                    ),
                    itemBuilder: (context, index) {
                      final c = topCards[index];
                      return CardWidget(title: c.title, value: c.value, description: c.description, icon: c.icon, color: c.color);
                    },
                  ),
                  const SizedBox(height: 24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bottomCards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                      childAspectRatio: isMobile ? 2.5 : 304 / 164,
                    ),
                    itemBuilder: (context, index) {
                      final c = bottomCards[index];
                      return CardWidget(title: c.title, value: c.value, description: c.description, icon: c.icon, color: c.color);
                    },
                  ),
                  const SizedBox(height: 24),
                  if (isMobile)
                    Column(children: [QuerySection(queries: queries), const SizedBox(height: 24), SidebarSction(metrics: metrics, overview: overview)])
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: QuerySection(queries: queries)),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: SidebarSction(metrics: metrics, overview: overview)),
                      ],
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<StatCard> _buildTopCards(dynamic overview) => [
      StatCard(title: 'Total Tables', value: '${overview?.schemaSummary?.totalTables ?? 0}', description: 'Active in schema', icon: Icons.table_chart, color: AppTheme.primary),
      StatCard(title: 'Total Columns', value: '${overview?.schemaSummary?.totalColumns ?? 0}', description: 'Across all tables', icon: Icons.view_column, color: AppTheme.purple),
      StatCard(title: 'Primary Keys', value: '${overview?.schemaSummary?.totalPrimaryKeys ?? 0}', description: 'Unique identifiers', icon: Icons.key, color: AppTheme.orange),
      StatCard(title: 'Database Status',value: overview?.db?.database ?? 'N/A', description: 'Instance state', icon: Icons.storage, color: AppTheme.green),
  ];

  List<StatCard> _buildBottomCards(dynamic metrics) => [
      StatCard(title: 'Active Connections', value: '${metrics?.activeConnections ?? 0}', description: 'Current connections', icon: Icons.people_outline, color: AppTheme.primary),
      StatCard(title: 'Blocked Sessions', value: '${metrics?.blockedSessions ?? 0}', description: 'Waiting sessions', icon: Icons.block, color: AppTheme.purple),
      StatCard(title: 'Database Size', value: _formatBytes(metrics?.dbSizeBytes ?? 0), description: 'Storage usage', icon: Icons.storage, color: AppTheme.green),
  ];

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < sizes.length - 1) { size /= 1024; i++; }
    return '${size.toStringAsFixed(1)} ${sizes[i]}';
  }
}