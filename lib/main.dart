import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/Auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DBaasApp());
}

class DBaasApp extends StatelessWidget {
  const DBaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        RegisterScreen.routeName:(_)=>RegisterScreen(),
      },
      initialRoute: RegisterScreen.routeName,
      theme:AppTheme.lightTheme ,
      darkTheme:AppTheme.darkTheme ,
      themeMode: ThemeMode.light,
    );
  }
}
