import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';


class FullCollectionScreen extends StatefulWidget {
  final String projectId;
  final Function(String collectionName) onCollectionSelected;

  const FullCollectionScreen({
    super.key,
    required this.projectId,
    required this.onCollectionSelected,
  });

  @override
  State createState() => _FullCollectionScreenState();
}

class _FullCollectionScreenState extends State<FullCollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDark;

    return BlocConsumer<MongoCollectionsCubit, MongoCollectionsStates>(
      listener: (context, state) {
        if (state is CreateMongoCollectionSuccess ||
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
            .where((c) => c.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

        return Padding(
          padding: EdgeInsets.all(24.r),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.gray : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildHeader(isDark, filtered.length),
                Expanded(
                  child: (state is GetMongoCollectionsLoading &&
                          collections.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : _buildList(filtered),
                ),
                _buildAddButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(List collections) {
    if (collections.isEmpty) {
      return const Center(child: Text('No Collections found'));
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];

        return _CollectionItem(
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
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.dataset, color: Colors.blue),
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
          SizedBox(height: 12.h),
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
      padding: EdgeInsets.all(20.r),
      child: ElevatedButton.icon(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Collection'),
      ),
    );
  }
}
class _CollectionItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CollectionItem({
    required this.name,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: Text(name),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}