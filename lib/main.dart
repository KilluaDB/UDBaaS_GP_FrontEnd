import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/Auth/presentation/screens/register_screen.dart';
import 'package:dbaas_project/features/cloud_feature/presentation/cloud_tab.dart';
import 'package:dbaas_project/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(DBaasApp());
}

class DBaasApp extends StatelessWidget {
  const DBaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {CloudTab.routeName: (_) => CloudTab(),
          HomeScreen.routeName:(_)=>HomeScreen(),
          RegisterScreen.routeName:(_)=>RegisterScreen()
          },
          initialRoute: HomeScreen.routeName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}
