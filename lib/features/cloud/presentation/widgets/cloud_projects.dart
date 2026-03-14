import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/projects/view/widgets/project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
class CloudProjects extends StatelessWidget {
  final List<ProjectModel> projects;

  const CloudProjects({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final settingsProvider = context.watch<SettingsProvider>();

    final cloudTypes = ["AWS", "Firebase", "Supabase", "Mongo Atlas","free"];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount = 1;
        if (width >= 1200) {
          crossAxisCount = 4;
        } else if (width >= 900) {
          crossAxisCount = 3;
        } else if (width >= 600) {
          crossAxisCount = 2;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cloudTypes.map((type) {
              final projectsOfType =
                  projects.where((p) => p.resourceTier == type).toList();

              if (projectsOfType.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  /// Header
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.cloudLogo,
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: settingsProvider.isDark
                                  ? AppTheme.white
                                  : AppTheme.black,
                            ),
                          ),
                          Text(
                            "${projectsOfType.length} Projects",
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 313 / 300,
                    ),
                    itemCount: projectsOfType.length,
                    itemBuilder: (context, index) {
                      return ProjectView(
                        project: projectsOfType[index],
                        onDelete: () {
                          context
                              .read<ProjectCubit>()
                              .deleteProject(projectsOfType[index].id!);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
