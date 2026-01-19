import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/projects/view/widgets/create_project_section.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CreateProjectPage extends StatefulWidget {
  static const String routeName = '/createProject';

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations local = AppLocalizations.of(context)!;

    SettingsProvider provider = Provider.of<SettingsProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocProvider(
  create: (context) => ProjectCubit(userProvider: context.read<UserProvider>()),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;
              bool isTablet =
                  constraints.maxWidth >= 600 && constraints.maxWidth < 1000;
              bool isDesktop = constraints.maxWidth >= 1000;
        
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppTheme.boldGray,
                        ),
                      ),
                      Text(local.backToProjects, style: textTheme.titleMedium!.copyWith(        color: provider.isDark
                      ? AppTheme.white
                      : AppTheme.black,)),
                    ],
                  ),
        
                  SizedBox(height: isMobile ? 10 : 20),
        
                  Expanded(
                    child: Align(
                      alignment: isMobile
                          ? Alignment.topCenter
                          : Alignment.center,
                      child: SizedBox(
                        width: isDesktop
                            ? screenWidth * 0.40
                            : isTablet
                            ? screenWidth * 0.55
                            : screenWidth * 0.95,
                        child: CreateProjectSection(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
