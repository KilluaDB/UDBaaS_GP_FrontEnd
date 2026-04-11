import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/state_card.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final StatCard state;
  const CardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      color: AppTheme.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.gray.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(state.title, style: textTheme.titleSmall),
            
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: state.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(state.icon, color: state.color, size: 18),
                ),
              ],
            ),

            const Spacer(),

            Text(
              state.value,
              style: textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              state.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
