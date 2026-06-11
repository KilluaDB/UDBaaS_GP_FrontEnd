import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/project_info/presentation/widgets/accsess_info.dart';
import 'package:dbaas_project/features/project_info/view_model/project_info_cubit.dart';
import 'package:dbaas_project/features/project_info/view_model/project_info_states.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class ProjectAccessSection extends StatelessWidget {
  const ProjectAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
        final settings = Provider.of<SettingsProvider>(context, listen: false);

    return BlocBuilder<ProjectAccessCubit, ProjectAccessState>(
      builder: (context, state) {
        final cubit = context.read<ProjectAccessCubit>();
        final data = cubit.accessData;

        if (state is GetProjectAccessLoading && data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetProjectAccessError && data == null) {
          return Center(child: Text(state.message));
        }

        if (data == null) return const SizedBox();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "External Access",
                style: textTheme.titleMedium!.copyWith(color:settings.isDark?AppTheme.white :AppTheme.black,fontWeight: FontWeight.bold, fontSize: 18.sp )
              ),

              const SizedBox(height: 20),

              AccessInfoTile(
                title: "Connection String",
                value: data.connectionString,
              ),

            
              AccessInfoTile(
                title: "Host",
                value: data.host,
              ),

        
              AccessInfoTile(
                title: "Username",
                value: data.username,
              ),

          
              AccessInfoTile(
                title: "Password",
                value: data.password,
                isSecret: true,
              ),

             
              if (data.postgrestUrl != null)
                AccessInfoTile(
                  title: "PostgREST URL",
                  value: data.postgrestUrl!,
                ),

          
              if (data.apiKey != null)
                AccessInfoTile(
                  title: "API Key",
                  value: data.apiKey!,
                  isSecret: true,
                ),

            
              if (data.jwtSecret != null)
                AccessInfoTile(
                  title: "JWT Secret",
                  value: data.jwtSecret!,
                  isSecret: true,
                ),
            ],
          ),
        );
      },
    );
  }
}