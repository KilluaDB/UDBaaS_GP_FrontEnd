
import 'package:dbaas_project/core/app_theme.dart';
import 'package:flutter/material.dart';

class StatCard {
  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;

  StatCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
  
    required this.color,
  });
static List<StatCard> status = [
  StatCard(
    title: 'Total Tables',
    value: '1',
    description: 'Active in schema',
    icon: Icons.table_chart,
    color: AppTheme.primary, // Blue
  ),
  StatCard(
    title: 'Total Columns',
    value: '1',
    description: 'Across all tables',
    icon: Icons.view_column,
    color:  AppTheme.purple, // Purple
  ),
  StatCard(
    title: 'Primary Keys',
    value: '1',
    description: 'Unique identifiers',
    icon: Icons.key,
    color: AppTheme.orange , // Orange
  ),
  StatCard(
    title: 'Relationships',
    value: '0',
    description: 'Foreign key links',
    icon: Icons.account_tree,
    color: AppTheme.green, // Green
  ),
  StatCard(
    title: 'Active Connections',
    value: '23',
    description: 'Current database connections',
    icon: Icons.people_outline,
    color: AppTheme.primary, // Blue
  ),
  StatCard(
    title: 'Total Queries',
    value: '24',
    description: 'Success rate: 95.8%',
    icon: Icons.bar_chart,
    color: AppTheme.purple, // Purple
  ),
  StatCard(
    title: 'Database Size',
    value: '2.5 MB',
    description: 'Estimated storage usage',
    icon: Icons.storage,
    color: AppTheme.green,// Green
  ),
];
}
