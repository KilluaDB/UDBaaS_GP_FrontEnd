import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view/widgets/input_section.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view/widgets/schema_preview.dart';
import 'package:flutter/material.dart';

class SchemeGenerator extends StatelessWidget {
  ProjectModel project;
   SchemeGenerator({required this.project});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Schema Generator",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Generate intelligent database schemas from your data using AI',
              style: textTheme.titleMedium,
            ),
            SizedBox(height: 24),
            InputSection(project: project,),
            SizedBox(height: 24),
            SchemaPreview(project: project,),
          ],
        ),
      ),
    );
  }
}
