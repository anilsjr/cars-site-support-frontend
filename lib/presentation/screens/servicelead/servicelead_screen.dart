import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/servicelead.dart';
import '../../controllers/servicelead_controller.dart';
import '../../bindings/servicelead_binding.dart';

class ServiceLeadScreen extends StatefulWidget {
  const ServiceLeadScreen({super.key});

  @override
  State<ServiceLeadScreen> createState() => _ServiceLeadScreenState();
}

class _ServiceLeadScreenState extends State<ServiceLeadScreen> {
  late ServiceLeadController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize service lead dependencies first
    ServiceLeadBinding().dependencies();
    _controller = Get.find<ServiceLeadController>();
    _controller.loadServiceLeads();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          _buildFiltersAndSearch(theme),
          Expanded(child: _buildDataTable(theme)),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, color: AppTheme.primaryMedium, size: 28),
          // const SizedBox(width: 12),
          Text(
            'Service Leads',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Obx(() => _buildSummaryCards()),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _buildSummaryCard(
          'Total',
          _controller.totalCount.value,
          AppTheme.primaryMedium,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Annual',
          _controller.annualCount.value,
          Colors.orange,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard('WGM', _controller.wgmCount.value, Colors.green),
      ],
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by VIN, Registration, Model...',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryMedium),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (value) => _controller.searchServiceLeads(value),
            ),
          ),
          const SizedBox(width: 16),
          Obx(
            () => DropdownButton<String>(
              value: _controller.selectedStatus.value.isEmpty
                  ? null
                  : _controller.selectedStatus.value,
              hint: const Text('Status'),
              items: ['All', 'Pending', 'Completed', 'In Progress']
                  .map(
                    (status) => DropdownMenuItem(
                      value: status == 'All' ? '' : status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
              onChanged: (value) => _controller.filterByStatus(value ?? ''),
            ),
          ),
          const SizedBox(width: 16),
          Obx(
            () => DropdownButton<String>(
              value: _controller.selectedServiceType.value.isEmpty
                  ? null
                  : _controller.selectedServiceType.value,
              hint: const Text('Service Type'),
              items: ['All', 'WGM', 'Annual']
                  .map(
                    (type) => DropdownMenuItem(
                      value: type == 'All' ? '' : type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  _controller.filterByServiceType(value ?? ''),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _controller.loadServiceLeads(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryMedium,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(ThemeData theme) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_controller.serviceLeads.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No service leads found',
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1040, // Total width of all columns (50+100+120+120+140+130+100+100+80)
                child: _buildTableHeader(theme),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1040, // Same total width
                  child: ListView.builder(
                    itemCount: _controller.serviceLeads.length,
                    itemBuilder: (context, index) {
                      final serviceLead = _controller.serviceLeads[index];
                      return _buildTableRow(serviceLead, index, theme);
                    },
                  ),
                ),
              ),
            ),
            _buildPagination(theme),
          ],
        ),
      );
    });
  }

  Widget _buildTableHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('ID', width: 50),
          _buildHeaderCell('Order Type', width: 100),
          _buildHeaderCell('Model No', width: 120),
          _buildHeaderCell('VIN No', width: 120),
          _buildHeaderCell('Registration', width: 140),
          _buildHeaderCell('Schedule Date', width: 130),
          _buildHeaderCell('Status', width: 100),
          _buildHeaderCell('Service Type', width: 100),
          _buildHeaderCell('Actions', width: 80),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {required double width}) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTableRow(ServiceLead serviceLead, int index, ThemeData theme) {
    final isEven = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(serviceLead.numericId.toString(), width: 50),
          _buildDataCell(serviceLead.orderType, width: 100),
          _buildDataCell(serviceLead.modelNo, width: 120, isWrappable: true),
          _buildDataCell(serviceLead.vinNo, width: 120),
          _buildDataCell(serviceLead.registrationNo, width: 140),
          _buildDataCell(
            DateFormat('dd/MM/yyyy').format(serviceLead.scheduleDate),
            width: 130,
          ),
          _buildStatusCell(serviceLead.leadStatus, width: 100),
          _buildServiceTypeCell(serviceLead.serviceType, width: 100),
          _buildActionsCell(serviceLead, width: 80),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, {required double width, bool isWrappable = false}) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface),
        maxLines: isWrappable ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusCell(String status, {required double width}) {
    Color statusColor;
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      case 'completed':
        statusColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      case 'in progress':
        statusColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        backgroundColor = Colors.grey.withOpacity(0.1);
    }

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildServiceTypeCell(String serviceType, {required double width}) {
    final color = serviceType == 'WGM' ? Colors.green : Colors.blue;

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          serviceType,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildActionsCell(ServiceLead serviceLead, {required double width}) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showServiceLeadDetails(serviceLead),
            icon: const Icon(Icons.visibility),
            iconSize: 18,
            tooltip: 'View Details',
          ),
          IconButton(
            onPressed: () => _editServiceLead(serviceLead),
            icon: const Icon(Icons.edit),
            iconSize: 18,
            tooltip: 'Edit',
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(ThemeData theme) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          border: Border(
            top: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing ${(_controller.currentPage.value - 1) * _controller.limit.value + 1}'
              ' to ${_controller.currentPage.value * _controller.limit.value > _controller.totalItems.value ? _controller.totalItems.value : _controller.currentPage.value * _controller.limit.value}'
              ' of ${_controller.totalItems.value} entries',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _controller.currentPage.value > 1
                      ? () => _controller.goToPage(
                          _controller.currentPage.value - 1,
                        )
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                ...List.generate(
                  _controller.totalPages.value,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => _controller.goToPage(index + 1),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _controller.currentPage.value == index + 1
                              ? AppTheme.primaryMedium
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: _controller.currentPage.value == index + 1
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ).take(5),
                IconButton(
                  onPressed:
                      _controller.currentPage.value <
                          _controller.totalPages.value
                      ? () => _controller.goToPage(
                          _controller.currentPage.value + 1,
                        )
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceLeadDetails(ServiceLead serviceLead) {
    showDialog(
      context: context,
      builder: (context) => ServiceLeadDetailsDialog(serviceLead: serviceLead),
    );
  }

  void _editServiceLead(ServiceLead serviceLead) {
    // Navigate to edit screen or show edit dialog
    Get.snackbar(
      'Info',
      'Edit functionality will be implemented',
      snackPosition: SnackPosition.TOP,
    );
  }
}

class ServiceLeadDetailsDialog extends StatelessWidget {
  final ServiceLead serviceLead;

  const ServiceLeadDetailsDialog({super.key, required this.serviceLead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: AppTheme.primaryMedium),
                const SizedBox(width: 12),
                Text(
                  'Service Lead Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('ID', serviceLead.numericId.toString(), theme),
            _buildDetailRow('Order Type', serviceLead.orderType, theme),
            _buildDetailRow('Model No', serviceLead.modelNo, theme),
            _buildDetailRow('VIN No', serviceLead.vinNo, theme),
            _buildDetailRow('Chassis No', serviceLead.chassisNo, theme),
            _buildDetailRow(
              'Registration No',
              serviceLead.registrationNo,
              theme,
            ),
            _buildDetailRow(
              'Schedule Date',
              DateFormat('dd/MM/yyyy HH:mm').format(serviceLead.scheduleDate),
              theme,
            ),
            _buildDetailRow('Lead Status', serviceLead.leadStatus, theme),
            _buildDetailRow('Service Type', serviceLead.serviceType, theme),
            _buildDetailRow('Remark', serviceLead.remark, theme),
            _buildDetailRow('Plant Code', serviceLead.plantCode, theme),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
