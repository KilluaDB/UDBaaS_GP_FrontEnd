import 'package:dbaas_project/core/constants/app_images.dart';

class Tabs {
  List<Map<String, String>> tabsData = [
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
}
