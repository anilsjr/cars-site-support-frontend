import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/servicelead.dart';
import '../../controllers/servicelead_controller.dart';

class ServiceLeadScreen extends StatefulWidget {
  const ServiceLeadScreen({super.key});

  @override
  State<ServiceLeadScreen> createState() => _ServiceLeadScreenState();
}

class _ServiceLeadScreenState extends State<ServiceLeadScreen>
    with TickerProviderStateMixin {
  late ServiceLeadController _controller = Get.find<ServiceLeadController>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  // Add reactive variable for search text
  final RxString _searchText = ''.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize service lead dependencies first
    _controller = Get.find<ServiceLeadController>();
    _controller.loadServiceLeads();

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
    _controller.searchServiceLeads(_searchController.text);
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
                      Expanded(child: _buildServiceLeadsList(theme)),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 800, // Total width of all columns
                      child: Column(
                        children: [
                          _buildTableHeader(theme),
                          Expanded(child: _buildServiceLeadsList(theme)),
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
            'Service Leads',
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
      width: 300, // Fixed width
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 40, // Reduced height
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8), // Reduced border radius
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4, // Reduced blur
            offset: const Offset(0, 1), // Reduced offset
          ),
        ],
      ),
      child: Obx(
        () => TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
          indicator: BoxDecoration(
            color: AppTheme.primaryMedium,
            borderRadius: BorderRadius.circular(6), // Reduced border radius
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(3), // Reduced padding
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11, // Reduced font size
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11, // Reduced font size
          ),
          dividerColor: Colors.transparent,
          onTap: (index) {
            switch (index) {
              case 0:
                _controller.filterByServiceType('');
                break;
              case 1:
                _controller.filterByServiceType('annual');
                break;
              case 2:
                _controller.filterByServiceType('wgm');
                break;
            }
          },
          tabs: [
            Tab(text: 'All (${_controller.totalCount.value})'),
            Tab(text: 'Annual (${_controller.annualCount.value})'),
            Tab(text: 'WGM (${_controller.wgmCount.value})'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      width: 500,
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Obx(
              () => TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Chassis / Fleet No (Door No)',
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
                              _controller.searchServiceLeads('');
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
          // Model Column
          isWideScreen
              ? Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      'Model',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: 160,
                  child: Text(
                    'Model',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
          // Door No
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Door No.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 60,
                  child: Text(
                    'Door No.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Chassis No
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Chassis No.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 90,
                  child: Text(
                    'Chassis No.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Registration No
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Registration No.',
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
                    'Registration No.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Schedule Date
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Schedule Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 90,
                  child: Text(
                    'Schedule Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Lead Status
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    'Lead Status',
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
                    'Lead Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Reschedule Count
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Reschd Count',
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
                    'Reschd Count',
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

  Widget _buildServiceLeadsList(ThemeData theme) {
    return Obx(
      () => _controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _controller.serviceLeads.isEmpty
          ? const Center(
              child: Text(
                'No service leads found',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: _controller.serviceLeads.length,
              itemBuilder: (context, index) {
                final lead = _controller.serviceLeads[index];
                return _buildServiceLeadCard(lead, theme);
              },
            ),
    );
  }

  Widget _buildServiceLeadCard(ServiceLead lead, ThemeData theme) {
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
          // Model Column
          isWideScreen
              ? Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      lead.modelNo,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : SizedBox(
                  width: 180,
                  child: Text(
                    lead.modelNo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
          // Door No
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    lead.doorNo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 60,
                  child: Text(
                    lead.doorNo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Chassis No
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    lead.chassisNo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                  ),
                )
              : SizedBox(
                  width: 90,
                  child: Text(
                    lead.chassisNo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
          // Registration No
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    lead.registrationNo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                  ),
                )
              : SizedBox(
                  width: 110,
                  child: Text(
                    lead.registrationNo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
          // Schedule Date
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Text(
                    DateFormat('dd/MM/yy').format(lead.scheduleDate),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 90,
                  child: Text(
                    DateFormat('dd/MM/yy').format(lead.scheduleDate),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Lead Status
          isWideScreen
              ? Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: _buildStatusBadge(lead.leadStatus, theme),
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Container(
                    alignment: Alignment.center,
                    child: _buildStatusBadge(lead.leadStatus, theme),
                  ),
                ),
          // Reschedule Count
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    lead.rescheduledCount.toString(),
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
                    lead.rescheduledCount.toString(),
                    style: TextStyle(
                      fontSize: 13,
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
      case 'pending':
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey.shade700;
        break;
      case 'in progress':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange.shade700;
        break;
      case 'completed':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green.shade700;
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
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ), // Reduced padding
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
                      _controller.loadServiceLeads();
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
                          _controller.loadServiceLeads();
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
                          _controller.loadServiceLeads();
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
                      labelText: 'Lead Status',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Pending', 'In Progress', 'Completed', 'Cancelled']
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
                            final DateTime maxDate =
                                _controller.endDate.value != null
                                ? (_controller.endDate.value!.isAfter(
                                        DateTime(2023),
                                      )
                                      ? _controller.endDate.value!
                                      : DateTime.now())
                                : DateTime.now();

                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  _controller.startDate.value ??
                                  (DateTime(2023).isBefore(maxDate)
                                      ? DateTime(2023)
                                      : maxDate),
                              firstDate: DateTime(2023),
                              lastDate: maxDate,
                            );
                            if (date != null) {
                              _controller.startDate.value = date;
                              // Reset end date if it's before the new start date
                              if (_controller.endDate.value != null &&
                                  _controller.endDate.value!.isBefore(date)) {
                                _controller.endDate.value = null;
                              }
                              _controller.loadServiceLeads();
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
                            final DateTime minDate =
                                _controller.startDate.value ??
                                DateTime(2023, 1, 1);
                            final DateTime initialDate =
                                _controller.endDate.value != null
                                ? (_controller.endDate.value!.isBefore(minDate)
                                      ? minDate
                                      : _controller.endDate.value!)
                                : (minDate.isBefore(DateTime.now())
                                      ? DateTime.now()
                                      : minDate);

                            final date = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: minDate,
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _controller.endDate.value = date;
                              _controller.loadServiceLeads();
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
                _controller.loadServiceLeads();
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
    _controller.refreshServiceLeads();
  }
}
