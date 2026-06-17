import 'dart:ui_web' as ui;
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view_model/geneartion_states.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view_model/generation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SchemaPreview extends StatefulWidget {
  final ProjectModel project;

  const SchemaPreview({super.key, required this.project});

  @override
  State createState() => _SchemaPreviewState();
}

class _SchemaPreviewState extends State<SchemaPreview> {
  final String viewId = "schema-mermaid-container";
  bool _registered = false;

  @override
  void initState() {
    super.initState();

    if (!_registered) {
      ui.platformViewRegistry.registerViewFactory(
        viewId,
        (int id) => html.DivElement()
          ..id = viewId
          ..style.width = "100%"
          ..style.height = "100%"
          ..style.overflow = "auto",
      );
      _registered = true;
    }
  }
void _editSchema(BuildContext context) {
  final cubit = context.read<SchemaGenerationCubit>();

  final state = cubit.state;

  if (state is GenerateSchemaSuccess) {
    cubit.setPromptForEdit(cubit.currentPrompt);
  }
}
void _declineSchema(BuildContext context) {
  context.read<SchemaGenerationCubit>().clearGeneratedSchema();
}
  void _renderMermaid(String code) {
    js.context.callMethod("renderMermaid", [viewId, code]);
  }

  void _zoomIn() => js.context.callMethod("zoomIn");
  void _zoomOut() => js.context.callMethod("zoomOut");
  void _reset() => js.context.callMethod("resetZoom");

  void _approve(BuildContext context) {
    context.read<SchemaGenerationCubit>().approveSchema(
      projectId: widget.project.id!,
    );
    context.read<SchemaGenerationCubit>().clearGeneratedSchema();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<SchemaGenerationCubit, SchemaGenerationStates>(
      listener: (context, state) async {
        if (state is GenerateSchemaSuccess) {
          final mermaid = state.response.data.mermaid;

          if (mermaid.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _renderMermaid(mermaid);
            });
          }
        }

        if (state is ApproveSchemaSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Schema approved successfully"),
              backgroundColor: Colors.green,
            ),
          );

          await context.read<PostgresTablesCubit>().getAllTables(
            widget.project.id!,
            isSilentRefresh: true,
          );
        }

        if (state is ApproveSchemaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<SchemaGenerationCubit, SchemaGenerationStates>(
        builder: (context, state) {
          final isApproving = state is ApproveSchemaLoading;

          Widget content;

          if (state is GenerateSchemaLoading || state is ApproveSchemaLoading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (state is GenerateSchemaSuccess) {
            content = Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schema_outlined),
                      const SizedBox(width: 8),
                      const Text(
                        "ER Diagram",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const Spacer(),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: isApproving ? null : () => _approve(context),
                        icon: isApproving
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(isApproving ? "Approving..." : "Approve"),
                      ),
                      const SizedBox(width: 8),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                        ),
onPressed: isApproving ? null : () => _editSchema(context),
icon: const Icon(Icons.edit),
label: const Text("Edit"),
                      ),
                      const SizedBox(width: 8),

                      ElevatedButton.icon(
                     
                       onPressed: isApproving ? null : () => _declineSchema(context),
icon: const Icon(Icons.close),
label: const Text("Decline"),
style: ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
),
                      ),

                      const SizedBox(width: 8),

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
                  child: Container(
                    color: const Color(0xFFF6F8FB),
                    child: HtmlElementView(viewType: viewId),
                  ),
                ),
              ],
            );
          } else if (state is GenerateSchemaError) {
            content = Center(
              child: Text(state.message, style: TextStyle(color: AppTheme.red)),
            );
          } else {
            content = _emptyState(textTheme, settings);
          }

          return SizedBox(
            height: 500,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(14),
                color: settings.isDark ? AppTheme.black : AppTheme.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schema_outlined, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        "Schema Preview",
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: settings.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(child: content),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState(TextTheme textTheme, SettingsProvider settings) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_outlined, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text("No schema generated yet", style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            "Generate schema to visualize ER diagram",
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
