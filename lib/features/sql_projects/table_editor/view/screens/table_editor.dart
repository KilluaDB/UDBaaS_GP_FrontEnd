// import 'package:dbaas_project/core/util/ui_utils.dart';
// import 'package:dbaas_project/features/sql_projects/table_editor/view/screens/Editor_empty_screen.dart';
// import 'package:dbaas_project/features/sql_projects/table_editor/view/screens/editor_full_screen.dart';
// import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_cubit.dart';
// import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TableEditor extends StatefulWidget {
// final String tableName;
// final String projectId;
//   const TableEditor({super.key,required this.tableName,required this.projectId});

//   @override
//   State<TableEditor> createState() => _TableEditorState();
// }

// class _TableEditorState extends State<TableEditor> {
// @override
//   void initState() {
//     super.initState();
 
//     context.read<PostgresTableEditorCubit>().getAllRows(projectId: widget.projectId,tableName:widget.tableName);
//   }
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${widget.tableName} Editor ',
//             style: textTheme.headlineSmall,
//           ),
        
//           SizedBox(height: 24.h),

//           Expanded(
//             child: BlocConsumer<PostgresTableEditorCubit, PostgresTableEditorStates>(
//               listener: (context, state) {
//                 if (state is GetAllRowsError) {
//                   final isNewProjectError =
//                       state.message.contains('Invalid project ID') ||
//                       state.message.contains('schema name');

//                   if (!isNewProjectError) {
//                     UiUtils.showErrorMessage(context, state.message);
//                   }
//                 }

//                 if (state is InsertRowSuccess) {
//                   UiUtils.showSuccessMessage(
//                     context,
//                     "Row Inserted successfully",
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 final cubit = context.read<PostgresTableEditorCubit>();

//                 if (state is GetAllRowsLoading &&
//                     cubit.cachedRows == null) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (state is GetAllRowsSuccess) {
//                   final RowList = state.GetRowsResponse.rows ?? [];

//                   if (RowList.isEmpty) {
//                     return  EditorEmptyScreen( projectId: widget.projectId,tableName: widget.tableName,);
//                   }

//                   return EditorFullScreen(
//                     projectId: widget.projectId,tableName: widget.tableName,
                  
//                   );
//                 }

//                 if (cubit.cachedRows != null) {
//                   final RowList = cubit.cachedRows!.rows ;

//                   if (RowList.isEmpty) {
//                       return  EditorEmptyScreen( projectId: widget.projectId,tableName: widget.tableName,);
//                   }
//    return EditorFullScreen(
//                     projectId: widget.projectId,tableName: widget.tableName,
                  
//                   );
//                 }
//    return  EditorEmptyScreen( projectId: widget.projectId,tableName: widget.tableName,);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class TableEditor extends StatelessWidget {
final String tableName;
final String projectId;
  const TableEditor({super.key,required this.tableName,required this.projectId});


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}