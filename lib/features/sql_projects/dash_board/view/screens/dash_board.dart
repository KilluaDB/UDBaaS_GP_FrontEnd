import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/empty_screen.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/full_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DashBoard extends StatefulWidget {
  final ProjectModel project;
  const DashBoard({super.key, required this.project});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: BlocConsumer<PostgresTablesCubit, PostgresTablesStates>(
        listener: (context, state) {
          if (state is GetAllTablesLoading) {
            UiUtils.showLoading(context);
          } else {
            UiUtils.hideLoading();
          }

          if (state is GetAllTablesError) {
            bool isNewProjectSchemaError =
                state.message.contains('Invalid project ID') ||
                state.message.contains('schema name');

            if (!isNewProjectSchemaError) {
              UiUtils.showErrorMessage(context, state.message);
            }
          }
        },
        builder: (context, state) {
          if (state is GetAllTablesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetAllTablesSuccess) {
            final tablesList =
                (state.getTablesSuccessResponse.data as List?) ?? [];

            if (tablesList.isEmpty) {
              return const EmptyScreen();
            } else {
              return DashboardFullScreen(project: widget.project);
            }
          }

          return const EmptyScreen();
        },
      ),
    );
  }
}
