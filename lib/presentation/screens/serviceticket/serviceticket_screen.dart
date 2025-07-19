import 'package:flutter/foundation.dart' show kDebugMode;
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
    if (kDebugMode) {
      print(
        'DEBUG: _onSearchChanged called with text: "${_searchController.text}"',
      );
    }
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
                      width: 1050, // Increased width to accommodate new columns
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment, color: AppTheme.primaryMedium, size: 28),
          const SizedBox(width: 20),
          Text(
            'My Service Tickets',
            style: TextStyle(
              fontSize: 20,
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
      width: 350, // Fixed width
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
                _controller.filterByStatus('inprogress');
                break;
              case 2:
                _controller.filterByServiceType('wgm');
                break;
            }
          },
          tabs: [
            Tab(text: 'Open (${_controller.totalCount.value})'),
            Tab(text: 'In Progress (${_controller.inProgressCount.value})'),
            Tab(text: 'Completed (${_controller.wgmCount.value})'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Chassis No./Boot No.',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 15,
                  ),
                  prefixIcon: _controller.isLoading.value
                      ? Container(
                          padding: const EdgeInsets.all(12),
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
                          color: AppTheme.primaryMedium,
                          size: 20,
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
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.primaryMedium,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withOpacity(0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
                ),
                onChanged: (value) {
                  // Search is now handled by the listener
                  // The controller's debounced search will be triggered automatically
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryMedium.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.tune, color: AppTheme.primaryMedium, size: 22),
              onPressed: () {
                _showAdvancedFilters(context);
              },
              tooltip: 'Advanced Filters',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          // Service Ticket ID Column
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Service Ticket ID',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : SizedBox(
                  width: 100,
                  child: Text(
                    'Service Ticket ID',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
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
                  flex: 2,
                  child: Text(
                    'Chassis No',
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
                    'Chassis No',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Fleet Door No
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Fleet/Door No',
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
                    'Fleet/Door No',
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
                  flex: 1,
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
          // Created On
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Created On',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 120,
                  child: Text(
                    'Created On',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Estimated Work Hrs
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Estimated Work Hrs',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: 130,
                  child: Text(
                    'Estimated Work Hrs',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          // Elapsed Time
          isWideScreen
              ? Expanded(
                  flex: 1,
                  child: Text(
                    'Elapsed Time',
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
                    'Elapsed Time',
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
                    'Action',
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
                    'Action',
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
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
          right: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Service Ticket ID Column
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        ticket.serviceTicketId.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                : SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        ticket.serviceTicketId.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                      overflow: TextOverflow.ellipsis,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Chassis
            isWideScreen
                ? Expanded(
                    flex: 2,
                    child: Text(
                      ticket.chassis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: 150,
                    child: Text(
                      ticket.chassis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Fleet Door No
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Text(
                      ticket.fleetDoorNo?.toString() ?? 'N/A',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: 110,
                    child: Text(
                      ticket.fleetDoorNo?.toString() ?? 'N/A',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Created By
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Text(
                      ticket.createdBy,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: 100,
                    child: Text(
                      ticket.createdBy,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Created On
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Text(
                      ticket.createdOn.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: 120,
                    child: Text(
                      ticket.createdOn.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Estimated Work Hrs
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Text(
                      '-', // Placeholder for estimated work hours
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: 130,
                    child: Text(
                      '-', // Placeholder for estimated work hours
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Elapsed Time
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Text(
                      '-', // Placeholder for elapsed time
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : SizedBox(
                    width: 110,
                    child: Text(
                      '-', // Placeholder for elapsed time
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            // Actions
            isWideScreen
                ? Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.visibility,
                          size: 18,
                          color: Colors.blue.shade700,
                        ),
                        onPressed: () {
                          // Handle view action
                        },
                        tooltip: 'View',
                      ),
                    ),
                  )
                : SizedBox(
                    width: 80,
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.visibility,
                          size: 18,
                          color: Colors.blue.shade700,
                        ),
                        onPressed: () {
                          // Handle view action
                        },
                        tooltip: 'View',
                      ),
                    ),
                  ),
          ],
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
