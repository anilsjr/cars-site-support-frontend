import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/serviceticket.dart';
import '../../controllers/serviceticket_controller.dart';

class ServiceTicketScreen extends StatefulWidget {
  const ServiceTicketScreen({super.key});

  @override
  State<ServiceTicketScreen> createState() => _ServiceTicketScreenState();
}

class _ServiceTicketScreenState extends State<ServiceTicketScreen>
    with TickerProviderStateMixin {
  late ServiceTicketController _controller =
      Get.find<ServiceTicketController>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  // Add reactive variable for search text
  final RxString _searchText = ''.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize service lead dependencies first
    _controller = Get.find<ServiceTicketController>();
    _controller.loadServiceTickets();

    // Listen to search text changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Search change handler with debouncing
  void _onSearchChanged() {
    print(
      'DEBUG: _onSearchChanged called with text: "${_searchController.text}"',
    );
    _searchText.value = _searchController.text;
    _controller.searchServiceTickets(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          _buildTabFilters(theme),
          _buildSearchBar(theme),
          Expanded(
            child: isWideScreen
                ? Column(
                    children: [
                      _buildTableHeader(theme),
                      Expanded(child: _buildServiceTicketsList(theme)),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 720, // Updated width for new columns
                      child: Column(
                        children: [
                          _buildTableHeader(theme),
                          Expanded(child: _buildServiceTicketsList(theme)),
                        ],
                      ),
                    ),
                  ),
          ),
          _buildPagination(theme),
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
      child: Row(
        children: [
          Icon(Icons.assignment, color: AppTheme.primaryMedium, size: 28),
          const SizedBox(width: 12),
          Text(
            'Service Tickets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
          // User profile section can be added here if needed
        ],
      ),
    );
  }

  Widget _buildTabFilters(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(
        () => TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryMedium,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: AppTheme.primaryMedium,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          onTap: (index) {
            switch (index) {
              case 0:
                _controller.filterByServiceType('');
                break;
              case 1:
                _controller.filterByStatus('inprogress');
                break;
              case 2:
                _controller.filterByServiceType('wgm');
                break;
            }
          },
          tabs: [
            Tab(text: 'All (${_controller.totalCount.value})'),
            Tab(text: 'In Progress (${_controller.inProgressCount.value})'),
            Tab(text: 'WGM (${_controller.wgmCount.value})'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      width: 500,
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Obx(
              () => TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Service Ticket ID / Chassis',
                  prefixIcon: _controller.isLoading.value
                      ? Container(
                          padding: const EdgeInsets.all(14),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryMedium,
                              ),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.search,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                  suffixIcon: Obx(
                    () => _searchText.value.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _searchText.value = '';
                              _controller.searchServiceTickets('');
                            },
                          )
                        : const SizedBox.shrink(),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  // Search is now handled by the listener
                  // The controller's debounced search will be triggered automatically
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () {
              _showAdvancedFilters(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          // Service Ticket ID Column
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      'Ticket ID',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Text(
                    'Ticket ID',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
          // Service Type
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Service Type',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 80,
                  child: Text(
                    'Service Type',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Chassis
          isWideScreen
              ? Expanded(
                  flex: 3,
                  child: Text(
                    'Chassis',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 150,
                  child: Text(
                    'Chassis',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Camp In Date
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Camp In Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 110,
                  child: Text(
                    'Camp In Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Status
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Created By
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Created By',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Text(
                    'Created By',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Actions
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 70,
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildServiceTicketsList(ThemeData theme) {
    return Obx(
      () => _controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _controller.serviceTickets.isEmpty
          ? const Center(
              child: Text(
                'No service tickets found',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: _controller.serviceTickets.length,
              itemBuilder: (context, index) {
                final ticket = _controller.serviceTickets[index];
                return _buildServiceTicketCard(ticket, theme);
              },
            ),
    );
  }

  Widget _buildServiceTicketCard(ServiceTicket ticket, ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Service Ticket ID Column
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      ticket.serviceTicketId.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Text(
                    ticket.serviceTicketId.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
          // Service Type
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    ticket.serviceType,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 80,
                  child: Text(
                    ticket.serviceType,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Chassis
          isWideScreen
              ? Expanded(
                  flex: 3,
                  child: Text(
                    ticket.chassis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 150,
                  child: Text(
                    ticket.chassis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Camp In Date
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    DateFormat('dd/MM/yy').format(ticket.campInDateTime),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 110,
                  child: Text(
                    DateFormat('dd/MM/yy').format(ticket.campInDateTime),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Status
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: _buildStatusBadge(ticket.status, theme),
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Container(
                    alignment: Alignment.center,
                    child: _buildStatusBadge(ticket.status, theme),
                  ),
                ),
          // Created By
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    ticket.createdBy,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Text(
                    ticket.createdBy,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Actions
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () {
                        // Handle edit action
                      },
                      tooltip: 'Edit',
                    ),
                  ),
                )
              : SizedBox(
                  width: 70,
                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () {
                        // Handle edit action
                      },
                      tooltip: 'Edit',
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, ThemeData theme) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'inprogress':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange.shade700;
        break;
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green.shade700;
        break;
      case 'pending':
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey.shade700;
        break;
      default:
        backgroundColor = theme.colorScheme.surface;
        textColor = theme.colorScheme.onSurface;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPagination(ThemeData theme) {
    return Obx(() {
      final totalItems = _controller.totalItems.value;
      final totalPages = _controller.totalPages.value;
      final currentPage = _controller.currentPage.value;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Rows per page:',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _controller.limit.value,
                  items: [5, 10, 25, 50].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      _controller.limit.value = newValue;
                      _controller.currentPage.value = 1;
                      _controller.loadServiceTickets();
                    }
                  },
                  underline: Container(),
                ),
              ],
            ),
            Text(
              '${_getStartIndex(currentPage, _controller.limit.value) + 1} - ${_getEndIndex(currentPage, _controller.limit.value, totalItems)} of $totalItems',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () {
                          _controller.currentPage.value = currentPage - 1;
                          _controller.loadServiceTickets();
                        }
                      : null,
                ),
                Text(
                  '$currentPage of $totalPages',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < totalPages
                      ? () {
                          _controller.currentPage.value = currentPage + 1;
                          _controller.loadServiceTickets();
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // Helper methods for pagination display
  int _getStartIndex(int currentPage, int limit) => (currentPage - 1) * limit;

  int _getEndIndex(int currentPage, int limit, int totalItems) {
    final endIndex = currentPage * limit;
    return endIndex > totalItems ? totalItems : endIndex;
  }

  // Advanced filters dialog
  void _showAdvancedFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Advanced Filters'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status Filter
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: _controller.selectedStatus.value.isEmpty
                        ? null
                        : _controller.selectedStatus.value,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Pending', 'In Progress', 'Completed']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      _controller.filterByStatus(value ?? '');
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Date Range Filter
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text: _controller.startDate.value != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_controller.startDate.value!)
                                : '',
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  _controller.startDate.value ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              _controller.startDate.value = date;
                              _controller.loadServiceTickets();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                            text: _controller.endDate.value != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_controller.endDate.value!)
                                : '',
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  _controller.endDate.value ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              _controller.endDate.value = date;
                              _controller.loadServiceTickets();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear all filters
                _controller.selectedStatus.value = '';
                _controller.startDate.value = null;
                _controller.endDate.value = null;
                _controller.loadServiceTickets();
                Navigator.of(context).pop();
              },
              child: const Text('Clear All'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Add refresh functionality
  void _refreshData() {
    _controller.refreshServiceTickets();
  }
}
