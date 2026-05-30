import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class CardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;

  const CardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

@override
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final provider = Provider.of<SettingsProvider>(context);

  return Card(
    color: provider.isDark ? AppTheme.black : AppTheme.white,
    elevation: 0.5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: AppTheme.gray.withValues(alpha: 0.2)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.titleSmall!.copyWith(
                  color: provider.isDark
                      ? AppTheme.white
                      : AppTheme.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall!.copyWith(
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.black,
            ),
          ),
        ],
      ),
    ),
  );
}
}
