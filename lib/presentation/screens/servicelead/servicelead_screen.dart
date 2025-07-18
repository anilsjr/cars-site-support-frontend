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

class _ServiceLeadScreenState extends State<ServiceLeadScreen>
    with TickerProviderStateMixin {
  late ServiceLeadController _controller = Get.find<ServiceLeadController>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedTab = 'All';
  int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize service lead dependencies first
    ServiceLeadBinding().dependencies();
    _controller = Get.find<ServiceLeadController>();
    _controller.loadServiceLeads();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
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
          _buildTabFilters(theme),
          _buildSearchBar(theme),
          Expanded(
            child: Column(
              children: [
                _buildTableHeader(theme),
                Expanded(child: _buildServiceLeadsList(theme)),
              ],
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
            setState(() {
              switch (index) {
                case 0:
                  _selectedTab = 'All';
                  break;
                case 1:
                  _selectedTab = 'Annual';
                  break;
                case 2:
                  _selectedTab = 'WGM';
                  break;
              }
            });
            _filterServiceLeads();
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
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Chassis / Fleet No (Door No)',
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
                _filterServiceLeads();
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          // Model Column
          Expanded(
            flex: 2,
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
          Expanded(
            flex: 1,
            child: Text(
              'Door No.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Chassis No
          Expanded(
            flex: 2,
            child: Text(
              'Chassis No.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Registration No
          Expanded(
            flex: 2,
            child: Text(
              'Registration No.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Schedule Date
          Expanded(
            flex: 2,
            child: Text(
              'Schedule Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Lead Status
          Expanded(
            flex: 2,
            child: Text(
              'Lead Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Reschedule Count
          Expanded(
            flex: 1,
            child: Text(
              'Reschedule Count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Actions
          Expanded(
            flex: 1,
            child: Text(
              'Actions',
              style: TextStyle(
                fontSize: 14,
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
          : _getFilteredServiceLeads().isEmpty
          ? const Center(
              child: Text(
                'No service leads found',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _getPaginatedServiceLeads().length,
              itemBuilder: (context, index) {
                final lead = _getPaginatedServiceLeads()[index];
                return _buildServiceLeadCard(lead, theme);
              },
            ),
    );
  }

  Widget _buildServiceLeadCard(ServiceLead lead, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Model Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.modelNo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    lead.serviceType,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Door No
            Expanded(
              flex: 1,
              child: Text(
                lead.doorNo,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Chassis No
            Expanded(
              flex: 2,
              child: Text(
                lead.chassisNo,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Registration No
            Expanded(
              flex: 2,
              child: Text(
                lead.registrationNo,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Schedule Date
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('dd/MM/yyyy').format(lead.scheduleDate),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Lead Status
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: _buildStatusBadge(lead.leadStatus, theme),
              ),
            ),
            // Reschedule Count
            Expanded(
              flex: 1,
              child: Text(
                lead.rescheduledCount.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Actions
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  // Handle edit action
                },
                tooltip: 'Edit',
              ),
            ),
          ],
        ),
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
    final totalItems = _getFilteredServiceLeads().length;
    final totalPages = (totalItems / _rowsPerPage).ceil();

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
                value: _rowsPerPage,
                items: [5, 10, 25, 50].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _rowsPerPage = newValue ?? 10;
                    _currentPage = 1;
                  });
                },
                underline: Container(),
              ),
            ],
          ),
          Text(
            '${_getStartIndex() + 1} of ${totalItems > 0 ? _getEndIndex() : 0}',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              Text(
                '$_currentPage of $totalPages',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<ServiceLead> _getFilteredServiceLeads() {
    List<ServiceLead> filtered = _controller.serviceLeads.toList();

    // Filter by tab selection
    if (_selectedTab == 'Annual') {
      filtered = filtered
          .where((lead) => lead.serviceType.toLowerCase().contains('annual'))
          .toList();
    } else if (_selectedTab == 'WGM') {
      filtered = filtered
          .where((lead) => lead.serviceType.toLowerCase().contains('wgm'))
          .toList();
    }

    // Filter by search query
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where(
            (lead) =>
                lead.chassisNo.toLowerCase().contains(query) ||
                lead.doorNo.toLowerCase().contains(query) ||
                lead.registrationNo.toLowerCase().contains(query) ||
                lead.modelNo.toLowerCase().contains(query),
          )
          .toList();
    }

    return filtered;
  }

  List<ServiceLead> _getPaginatedServiceLeads() {
    final filtered = _getFilteredServiceLeads();
    final startIndex = _getStartIndex();
    final endIndex = _getEndIndex();

    if (startIndex >= filtered.length) return [];

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int _getStartIndex() => (_currentPage - 1) * _rowsPerPage;

  int _getEndIndex() => _currentPage * _rowsPerPage;

  void _filterServiceLeads() {
    setState(() {
      _currentPage = 1; // Reset to first page when filtering
    });
  }
}
