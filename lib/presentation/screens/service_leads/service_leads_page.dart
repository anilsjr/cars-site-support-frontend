import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_leads_controller.dart';
import '../../../domain/entities/service_lead.dart';

class ServiceLeadsPage extends StatelessWidget {
  const ServiceLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceLeadsController>(
      init: ServiceLeadsController(Get.find()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Service Leads'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.refreshData,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: Column(
            children: [
              // Search and Filter Section
              _buildSearchAndFilters(controller),

              // Data Table Section
              Expanded(child: _buildDataTable(controller)),

              // Pagination Controls
              _buildPaginationControls(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters(ServiceLeadsController controller) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search service leads...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: controller.applySearch,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () =>
                      controller.applySearch(controller.searchController.text),
                  child: const Text('Search'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: controller.clearSearch,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filters Row
            Row(
              children: [
                // Order Type Filter
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedOrderType.value.isEmpty
                          ? null
                          : controller.selectedOrderType.value,
                      decoration: const InputDecoration(
                        labelText: 'Order Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'annual',
                          child: Text('Annual'),
                        ),
                        DropdownMenuItem(value: 'wgm', child: Text('WGM')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) =>
                          controller.filterByOrderType(value ?? ''),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Status Filter
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedStatus.value.isEmpty
                          ? null
                          : controller.selectedStatus.value,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'processing',
                          child: Text('Processing'),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('Completed'),
                        ),
                        DropdownMenuItem(
                          value: 'cancelled',
                          child: Text('Cancelled'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.filterByStatus(value ?? ''),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Page Size Selector
                SizedBox(
                  width: 200,
                  child: Obx(
                    () => DropdownButtonFormField<int>(
                      value: controller.pageSize.value,
                      decoration: const InputDecoration(
                        labelText: 'Items per page',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.pageSizeOptions
                          .map(
                            (size) => DropdownMenuItem(
                              value: size,
                              child: Text('$size'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          controller.changePageSize(value ?? 10),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Clear Filters Button
                ElevatedButton(
                  onPressed: controller.clearAllFilters,
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(ServiceLeadsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error: ${controller.error.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshData,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (!controller.hasData) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No service leads found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return Card(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Table Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Service Leads (${controller.totalItems.value} total)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Data Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Order Type')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Vehicle')),
                      DataColumn(label: Text('Contact')),
                      DataColumn(label: Text('Service Type')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Created')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: controller.serviceLeads.map((serviceLead) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              serviceLead.id.length > 10
                                  ? '${serviceLead.id.substring(0, 10)}...'
                                  : serviceLead.id,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                          DataCell(
                            Chip(
                              label: Text(serviceLead.orderType),
                              backgroundColor: _getOrderTypeColor(
                                serviceLead.orderType,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              serviceLead.customerName ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Text(
                              serviceLead.vehicleNumber ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DataCell(Text(serviceLead.contactNumber ?? 'N/A')),
                          DataCell(
                            Text(
                              serviceLead.serviceType ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(_buildStatusChip(serviceLead.status)),
                          DataCell(
                            Text(
                              serviceLead.createdAt != null
                                  ? _formatDate(serviceLead.createdAt!)
                                  : 'N/A',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility, size: 18),
                                  onPressed: () =>
                                      _viewServiceLead(serviceLead),
                                  tooltip: 'View Details',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () =>
                                      _editServiceLead(serviceLead),
                                  tooltip: 'Edit',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPaginationControls(ServiceLeadsController controller) {
    return Obx(
      () => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              ElevatedButton.icon(
                onPressed: controller.canGoPrevious
                    ? controller.previousPage
                    : null,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Previous'),
              ),

              // Page info and direct page navigation
              Row(
                children: [
                  const Text('Page: '),
                  ...List.generate(
                    controller.totalPages.value.clamp(
                      0,
                      5,
                    ), // Show max 5 page buttons
                    (index) {
                      int pageNumber = index + 1;
                      bool isCurrentPage =
                          pageNumber == controller.currentPage.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ElevatedButton(
                          onPressed: () => controller.goToPage(pageNumber),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCurrentPage ? Colors.blue : null,
                            foregroundColor: isCurrentPage
                                ? Colors.white
                                : null,
                          ),
                          child: Text('$pageNumber'),
                        ),
                      );
                    },
                  ),
                  if (controller.totalPages.value > 5) ...[
                    const Text('...'),
                    ElevatedButton(
                      onPressed: () =>
                          controller.goToPage(controller.totalPages.value),
                      child: Text('${controller.totalPages.value}'),
                    ),
                  ],
                ],
              ),

              // Next button
              ElevatedButton.icon(
                onPressed: controller.canGoNext ? controller.nextPage : null,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    if (status == null) return const Text('N/A');

    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'processing':
        color = Colors.blue;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  Color _getOrderTypeColor(String orderType) {
    switch (orderType.toLowerCase()) {
      case 'annual':
        return Colors.green[100]!;
      case 'wgm':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _viewServiceLead(ServiceLead serviceLead) {
    Get.dialog(
      AlertDialog(
        title: Text('Service Lead Details - ${serviceLead.id}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Order Type', serviceLead.orderType),
              _buildDetailRow('Customer', serviceLead.customerName ?? 'N/A'),
              _buildDetailRow('Vehicle', serviceLead.vehicleNumber ?? 'N/A'),
              _buildDetailRow('Contact', serviceLead.contactNumber ?? 'N/A'),
              _buildDetailRow('Service Type', serviceLead.serviceType ?? 'N/A'),
              _buildDetailRow('Status', serviceLead.status ?? 'N/A'),
              _buildDetailRow(
                'Created',
                serviceLead.createdAt?.toString() ?? 'N/A',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _editServiceLead(ServiceLead serviceLead) {
    Get.snackbar(
      'Edit Service Lead',
      'Edit functionality for ${serviceLead.id} will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
