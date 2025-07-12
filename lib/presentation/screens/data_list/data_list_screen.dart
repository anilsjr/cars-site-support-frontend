import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/data_list_controller.dart';
import '../../widgets/responsive_widgets.dart';
import '../../../core/utils/responsive.dart';

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
      body: ResponsiveContainer(
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
            SizedBox(
              height: Responsive.getResponsiveValue(
                context,
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              ),
            ),

            // Data list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredData.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                return ResponsiveLayoutBuilder(
                  builder: (context, screenType, width) {
                    // On larger screens, we can use a more sophisticated layout
                    if (screenType == ResponsiveScreenType.desktop ||
                        screenType == ResponsiveScreenType.largeDesktop) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.getResponsiveValue(
                            context,
                            mobile: 1,
                            tablet: 2,
                            desktop: 2,
                            largeDesktop: 3,
                          ),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: controller.filteredData.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredData[index];
                          return _buildDataCard(item, index, context);
                        },
                      );
                    }

                    // On mobile and tablet, use traditional list view
                    return ListView.builder(
                      itemCount: controller.filteredData.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredData[index];
                        return _buildDataCard(item, index, context);
                      },
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

  Widget _buildDataCard(
    Map<String, dynamic> item,
    int index,
    BuildContext context,
  ) {
    return ResponsiveCard(
      margin: Responsive.getPadding(
        context,
        mobile: const EdgeInsets.symmetric(vertical: 4),
        tablet: const EdgeInsets.symmetric(vertical: 6),
        desktop: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: ListTile(
        leading: ResponsiveLayoutBuilder(
          builder: (context, screenType, width) {
            final size = Responsive.getResponsiveValue(
              context,
              mobile: 40.0,
              tablet: 45.0,
              desktop: 50.0,
            );
            return CircleAvatar(
              radius: size / 2,
              child: ResponsiveText(
                '${index + 1}',
                mobileFontSize: 14,
                tabletFontSize: 16,
                desktopFontSize: 18,
              ),
            );
          },
        ),
        title: ResponsiveText(
          item['title'] ?? 'No Title',
          mobileFontSize: 16,
          tabletFontSize: 17,
          desktopFontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        subtitle: ResponsiveText(
          item['description'] ?? 'No Description',
          mobileFontSize: 14,
          tabletFontSize: 15,
          desktopFontSize: 16,
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
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
  }
}
