import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/provider/project_provider.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/core/provider/user_provider.dart';
import 'package:dbaas_project/features/Auth/presentation/screens/register_screen.dart';
import 'package:dbaas_project/features/home/home_screen.dart';
import 'package:dbaas_project/features/projects/noSql_projects/screens/main_screen_noSql.dart';
import 'package:dbaas_project/features/projects/screens/create_project_screen.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/main_screen_sql.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = await SettingsProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: const DBaasApp(),
    ),
  );
}

class DBaasApp extends StatelessWidget {
  const DBaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
  
          debugShowCheckedModeBanner: false,
          routes: {
            HomeScreen.routeName: (_) =>  HomeScreen(),
            RegisterScreen.routeName: (_) =>  RegisterScreen(),
            CreateProjectPage.routeName: (_) =>  CreateProjectPage(),
            MainScreenNOSQL.routeName: (_) =>  MainScreenNOSQL(),
            MainScreenSQL.routeName: (_) =>  MainScreenSQL(),
          },
          initialRoute: HomeScreen.routeName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.currentMode,
        
        );
      },
    );
  }
}
