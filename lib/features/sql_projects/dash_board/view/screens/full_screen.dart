import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/state_card.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/query_section.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/widgets/sidebar_sction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/card_widget.dart';


class DashboardFullScreen extends StatelessWidget {


  DashboardFullScreen({super.key});
  @override
  Widget build(BuildContext context) {
   SettingsProvider provider = Provider.of<SettingsProvider>(context);

    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth < 1024 && constraints.maxWidth >= 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Monitor your database performance and metrics',
                style: textTheme.titleSmall!.copyWith(color: AppTheme.gray),
              ),
              const SizedBox(height: 32),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: isMobile ? 2.5 : 304 / 164,
                ),
                itemCount: 4,
                itemBuilder: (context, index) =>
                    CardWidget(state: StatCard.status[index]),
              ),
              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: isMobile ? 2.5 : 304 / 164,
                ),
                itemCount: 3,
                itemBuilder: (context, index) =>
                    CardWidget(state: StatCard.status[index + 4]),
              ),

              const SizedBox(height: 24),


              if (isMobile)
                Column(
                  children: [
                    QuerySection(),
                    const SizedBox(height: 24),
                    SidebarSction(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: QuerySection()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: SidebarSction()),
                  ],
                ),
                const SizedBox(height: 32),





            ],

          ),
        );
      },
    );
  }



}
