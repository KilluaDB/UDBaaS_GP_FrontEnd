import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view/screens/editor_empty_screen.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view/screens/full_screen.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_edior_states.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_editor_cubit.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CollectionEditor extends StatefulWidget {
  final ProjectModel project;
  final String collectionName;
  final Function() onOpenDrawer;

  const CollectionEditor({
    super.key,
    required this.project,
    required this.collectionName,
    required this.onOpenDrawer,
  });

  @override
  State<CollectionEditor> createState() => _CollectionEditorState();
}

class _CollectionEditorState extends State<CollectionEditor> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<MongoCollectionEditorCubit>();

      cubit.getDocuments(
        projectId: widget.project.id!,
        collectionName: widget.collectionName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<SettingsProvider>(context);

    final hasTableSelected = widget.collectionName.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 0.05.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Collections Editor",
            style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            'Edit Collection Documents and manage your database content',
            style: textTheme.titleMedium!.copyWith(
              fontSize: 16.sp,
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),

          SizedBox(height: 24.h),

          Expanded(
            child: !hasTableSelected
                ?  EditorEmptyScreen()
                : BlocConsumer<MongoCollectionEditorCubit,
                    MongoEditorStates>(
                    listener: (context, state) {
                      if (state is GetDocumentsLoading) {
                        UiUtils.showLoading(context);
                      } else if (state is GetDocumentsError) {
                        UiUtils.hideLoading();
                        UiUtils.showErrorMessage(context, state.message);
                      } else {
                        UiUtils.hideLoading();
                      }
                    },

                    builder: (context, state) {
                

                      return MongoCollectionFullScreen(
                        projectId: widget.project.id!,
                        collectionName: widget.collectionName,
                  
                        onOpenDrawer: widget.onOpenDrawer,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}