import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/util/validator.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CollectionDb extends StatefulWidget {
  final String projectId;

  const CollectionDb({
    super.key,
    required this.projectId,
  });

  @override
  State createState() => _CollectionDbState();
}

class _CollectionDbState extends State<CollectionDb> {
  late TextEditingController collectionNameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    collectionNameController = TextEditingController();
  }

  @override
  void dispose() {
    collectionNameController.dispose();
    super.dispose();
  }

  late MongoCollectionsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of(context);
    cubit = context.read<MongoCollectionsCubit>();

    return Drawer(
      backgroundColor: AppTheme.white,
      width: MediaQuery.of(context).size.width * 0.45,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.appIcon,
                      width: 40.w,
                      height: 40.h,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Create Collection',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                const Divider(),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Collection Name",
                          style: textTheme.titleSmall),

                      SizedBox(height: 8.h),

                      CustomTextFormField(
                        controller: collectionNameController,
                        validator: Validator.validateTableName,
                        hintText: 'e.g. users',
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "Use lowercase (e.g., user_profiles)",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),

                    SizedBox(width: 12.w),

                    BlocConsumer<MongoCollectionsCubit, MongoCollectionsStates>(
                      listenWhen: (previous, current) =>
                          current is GetMongoCollectionsError,
                      listener: (context, state) {
                        if (state is GetMongoCollectionsError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is GetMongoCollectionsLoading;

                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.createCollection(
                                      projectId: widget.projectId,
                                      name: collectionNameController.text.trim(),
                                    );
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Create Collection"),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}