import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tabs {
  bool isSql;
  Tabs({required this.isSql});
  static List<Map<String, String>> sqlTabs = [
    {
      'name': 'Dashboard',
      'selected': AppImages.dashBoardIconSelected,
      'unselected': AppImages.dashBoardIcon,
    },
    {
      'name': 'Tables',
      'selected': AppImages.tablesIconSelected,
      'unselected': AppImages.tablesIcon,
    },
    {
      'name': 'Table Editor',
      'selected': AppImages.editorIconSelected,
      'unselected': AppImages.editorIcon,
    },
    {
      'name': 'Query Editor',
      'selected': AppImages.queryIconSelected,
      'unselected': AppImages.queryIcon,
    },
    {
      'name': 'Schema Visualizer',
      'selected': AppImages.schemaVisualizerIconSelected,
      'unselected': AppImages.schemaVisualizerIcon,
    },
    {
      'name': 'Scheme Generator',
      'selected': AppImages.schemaGeneratorIconSelected,
      'unselected': AppImages.schemaGeneratorIcon,
    },
    {
      'name': 'Delete Project',

      'selected': AppImages.deleteIconSelected,
      'unselected': AppImages.deleteIcon,
    },
  ];
  static List<Map<String, String>> noSqlTabs = [
    {
      'name': 'Dashboard',
      'selected': AppImages.dashBoardIconSelected,
      'unselected': AppImages.dashBoardIcon,
    },
    {
      'name': 'Collections',
      'selected': AppImages.collectionIconSelected,
      'unselected': AppImages.collectionIcon,
    },
    {
      'name': 'Collection Editor',
      'selected': AppImages.editorIconSelected,
      'unselected': AppImages.editorIcon,
    },
    {
      'name': 'Delete Project',

      'selected': AppImages.deleteIconSelected,
      'unselected': AppImages.deleteIcon,
    },
  ];

  static get tabsData => null;
}
