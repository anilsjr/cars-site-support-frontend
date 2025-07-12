import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/data_list_controller.dart';

class DataListScreen extends GetView<DataListController> {
  const DataListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.filterData,
            ),
            const SizedBox(height: 16),

            // Data list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredData.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                return ListView.builder(
                  itemCount: controller.filteredData.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(item['title'] ?? 'No Title'),
                        subtitle: Text(item['description'] ?? 'No Description'),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              controller.editItem(item);
                            } else if (value == 'delete') {
                              controller.deleteItem(item);
                            }
                          },
                        ),
                        onTap: () => controller.viewItem(item),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addNewItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
