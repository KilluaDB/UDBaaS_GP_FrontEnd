import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/Auth/view/screens/register_screen.dart';
import 'package:dbaas_project/features/home/presentation/screens/home_screen.dart';
import 'package:dbaas_project/features/no_sql_projects/view/screens/main_screen_noSql.dart';
import 'package:dbaas_project/features/projects/view/screens/create_project_screen.dart';
import 'package:dbaas_project/features/sql_projects/main_screen_sql.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = await UserProvider.init();
  final settingsProvider = await SettingsProvider.init();


  runApp(
    MultiProvider(
      providers: [
         ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
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
    final userProvider = context.watch<UserProvider>();

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            RegisterScreen.routeName: (_) => RegisterScreen(),
            CreateProjectPage.routeName: (_) => CreateProjectPage(),
            MainScreenNOSQL.routeName: (_) => MainScreenNOSQL(),
            MainScreenSQL.routeName: (_) => MainScreenSQL(),
          },
          initialRoute: MainScreenSQL.routeName,
          // initialRoute: userProvider.currentUser==null?RegisterScreen.routeName:HomeScreen.routeName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
     
          themeMode: provider.currentMode,
        );
      },
    );
  }
}
