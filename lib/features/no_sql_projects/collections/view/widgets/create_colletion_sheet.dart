import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbaas_project/core/util/validator.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';

void showCreateCollectionSheet(
  BuildContext context,
  String projectId,
  MongoCollectionsCubit cubit,
) {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    // زيادة حواف الشيت لتكون أنعم وأكثر عصرية
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (sheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 32,
            left: 24,
            right: 24,
            top: 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 28),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const Text(
                  "New Collection",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter a unique name for your new data collection.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 28),
 CustomTextFormField(hintText:  "e.g. user_profiles",controller:controller,validator:Validator.validateTableName ,),

                const SizedBox(height: 10),
                
            
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      "Recommendation: use snake_case (e.g. my_data)",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

               
                BlocBuilder<MongoCollectionsCubit, MongoCollectionsStates>(
                  builder: (context, state) {
                    final isLoading = state is CreateMongoCollectionLoading;
                    return Center( 
                      child: SizedBox(
                        width: 190, 
                        height: 34,
                        child: CustomElevatedButton(onTap: isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    await context
                                        .read<MongoCollectionsCubit>()
                                        .createCollection(
                                          projectId: projectId,
                                          name: controller.text.trim(),
                                        );
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },child: isLoading
                              ?  SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Create Collection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),)
                        
                        
                        
                 
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).whenComplete(controller.dispose);
}