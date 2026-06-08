import 'package:dbaas_project/features/no_sql_projects/collections/view/widgets/create_colletion_sheet.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_editor_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FullCollectionScreen extends StatefulWidget {
  final String projectId;
  final Function(String collectionName) onCollectionSelected;

  const FullCollectionScreen({
    super.key,
    required this.projectId,
    required this.onCollectionSelected,
  });

  @override
  State<FullCollectionScreen> createState() => _FullCollectionScreenState();
}

class _FullCollectionScreenState extends State<FullCollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  late  TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDark;
    textTheme = Theme.of(context).textTheme;

    return BlocConsumer<MongoCollectionsCubit, MongoCollectionsStates>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is CreateMongoCollectionSuccess ||
            state is DeleteMongoCollectionSuccess ||
            state is GetMongoCollectionsError) {
          context.read<MongoCollectionsCubit>().getCollections(
            widget.projectId,
            isSilentRefresh: true,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.watch<MongoCollectionsCubit>();
        final collections = cubit.cachedCollections;

        final filtered = collections
            .where(
              (c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildHeader(isDark, filtered.length)),
                    const SizedBox(width: 16),
                    _buildAddButton(context),
                  ],
                ),

                const SizedBox(height: 12),

                Expanded(
                  child:
                      (state is GetMongoCollectionsLoading &&
                          collections.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : _buildGrid(filtered),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List collections) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];

        return _CollectionCard(
          name: collection.name,
          onTap: () {
            widget.onCollectionSelected(collection.name);
          },
          onDelete: () {
            context.read<MongoCollectionsCubit>().deleteCollection(
              projectId: widget.projectId,
              collectionName: collection.name,
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(bool isDark, int count) {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.dataset, color: Colors.blue),
              SizedBox(width: 8.w),
              Text(
                '$count Collections',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() => _searchQuery = val);
            },
            decoration: const InputDecoration(
              hintText: 'Search collections...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 180,
        child: ElevatedButton.icon(
          onPressed: () {
            final cubit = context.read<MongoCollectionsCubit>();
            showCreateCollectionSheet(context, widget.projectId, cubit);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Collection'),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CollectionCard({
    required this.name,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(left: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_outlined, color: Colors.blue, size: 26),
                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _row(
              "Documents",
              "${context.watch<MongoEditorCubit>().documentsCount}",
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(value, style: textTheme.bodySmall),
        ),
      ],
    );
  }
}
