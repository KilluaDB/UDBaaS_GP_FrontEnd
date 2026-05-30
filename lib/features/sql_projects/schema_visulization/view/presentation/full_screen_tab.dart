import 'dart:ui_web' as ui;
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view_model/schema_cubit.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view_model/schema_states.dart';

class FullScreenTab extends StatefulWidget {
  final ProjectModel project;

  const FullScreenTab({super.key, required this.project});

  @override
  State<FullScreenTab> createState() => _SchemaVisualizerState();
}

class _SchemaVisualizerState extends State<FullScreenTab> {
  final String viewId = 'mermaid-container';
  bool _registered = false;

  @override
  void initState() {
    super.initState();

    if (!_registered) {
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int id) => html.DivElement()
          ..id = viewId
          ..style.width = '100%'
          ..style.height = '100%',
      );
      _registered = true;
    }

    final userProvider =
        Provider.of<UserProvider>(context, listen: false);

    context.read<SchemaCubit>().visualizeSchema(
          projectId: widget.project.id!,
    
        );
  }

  String _fixMermaid(String input) {
    return input.replaceAll('PK FK', 'PK').replaceAll('  ', ' ');
  }

  void _renderMermaid(String code) {
    js.context.callMethod('renderMermaid', [viewId, code]);
  }

  // ===== JS Controls =====

  void _zoomIn() => js.context.callMethod('zoomIn');
  void _zoomOut() => js.context.callMethod('zoomOut');
  void _reset() => js.context.callMethod('resetZoom');

  @override
  Widget build(BuildContext context) {
    return BlocListener<SchemaCubit, SchemaStates>(
      listener: (context, state) {
        if (state is PostgresSchemaVisualizationSuccess) {
          Future.delayed(const Duration(milliseconds: 400), () {
            final fixed = _fixMermaid(state.response.data.mermaid);
            _renderMermaid(fixed);
          });
        }
      },
      child: BlocBuilder<SchemaCubit, SchemaStates>(
        builder: (context, state) {
          if (state is PostgresSchemaVisualizationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostgresSchemaVisualizationError) {
            return Center(child: Text(state.message));
          }

          if (state is PostgresSchemaVisualizationSuccess) {
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
              
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_tree_outlined),
                        const SizedBox(width: 8),
                        const Text(
                          "Database Schema Diagram",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),

                        IconButton(
                          icon: const Icon(Icons.zoom_in),
                          onPressed: _zoomIn,
                        ),
                        IconButton(
                          icon: const Icon(Icons.zoom_out),
                          onPressed: _zoomOut,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _reset,
                        ),
                      ],
                    ),
                  ),

            Expanded(
  child: SizedBox.expand(
    child: Container(
      color: const Color(0xFFeef4fb),
      child: HtmlElementView(viewType: viewId),
    ),
  ),
)
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}