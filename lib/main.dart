import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/core/provider/user_provider.dart';
import 'package:dbaas_project/features/Auth/presentation/screens/register_screen.dart';
import 'package:dbaas_project/features/home/home_screen.dart';
import 'package:dbaas_project/features/projects/screens/create_project_screen.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],

      child: DBaasApp(),
    ),
  );
}

class DBaasApp extends StatelessWidget {
  late SettingsProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
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
          },
          initialRoute: HomeScreen.routeName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.currentMode,
          locale: Locale(provider.languageMode),
        );
      },
    );
  }

  initSharedPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? theme = prefs.getString('currentMode');
    provider.changeLanguageMode(lang ?? 'en');
    if (theme == 'dark') {
      provider.changeThemeMode(ThemeMode.dark);
    }
    else if (theme == 'light') {
      provider.changeThemeMode(ThemeMode.light);
    }
  }
}
