import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/home/widgets/drawer_item.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
class HomeDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  HomeDrawer({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<Map<String, String>> tabs = [
    {
      'name': 'Projects',
      'selected': AppImages.projectSelected,
      'unselected': AppImages.projectUnSelected,
    },
    {
      'name': 'Cloud',
      'selected': AppImages.cloudSelected,
      'unselected': AppImages.cloudUnSelected,
    },
    {
      'name': 'Settings',
      'selected': AppImages.settingsSelected,
      'unselected': AppImages.settingsUnSelected,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
           AppLocalizations local = AppLocalizations.of(context)!;
    return Drawer(
     
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppImages.projectSelected,
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 8),
                Text(local.aiDbHub, style: textTheme.titleLarge),
              ],
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onItemSelected(index),
                    child: DrawerItem(
                      name: tabs[index]['name']!,
                      isSelected: selectedIndex == index,
                      selectedImage: tabs[index]['selected']!,
                      unselectedImage: tabs[index]['unselected']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
