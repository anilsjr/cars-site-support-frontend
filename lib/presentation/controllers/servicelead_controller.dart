import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/entities/servicelead.dart';
import '../../domain/usecases/servicelead_usecases.dart';

class ServiceLeadController extends GetxController {
  final GetServiceLeadsUseCase _getServiceLeadsUseCase;
  final GetServiceLeadByIdUseCase _getServiceLeadByIdUseCase;
  final CreateServiceLeadUseCase _createServiceLeadUseCase;
  final UpdateServiceLeadUseCase _updateServiceLeadUseCase;
  final DeleteServiceLeadUseCase _deleteServiceLeadUseCase;

  ServiceLeadController({
    required GetServiceLeadsUseCase getServiceLeadsUseCase,
    required GetServiceLeadByIdUseCase getServiceLeadByIdUseCase,
    required CreateServiceLeadUseCase createServiceLeadUseCase,
    required UpdateServiceLeadUseCase updateServiceLeadUseCase,
    required DeleteServiceLeadUseCase deleteServiceLeadUseCase,
  }) : _getServiceLeadsUseCase = getServiceLeadsUseCase,
       _getServiceLeadByIdUseCase = getServiceLeadByIdUseCase,
       _createServiceLeadUseCase = createServiceLeadUseCase,
       _updateServiceLeadUseCase = updateServiceLeadUseCase,
       _deleteServiceLeadUseCase = deleteServiceLeadUseCase;

  // Observable variables
  final RxList<ServiceLead> serviceLeads = <ServiceLead>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxInt limit = 10.obs;

  // Filters
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxString selectedServiceType = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Counts
  final RxInt totalCount = 0.obs;
  final RxInt annualCount = 0.obs;
  final RxInt wgmCount = 0.obs;

  // Search debouncing
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    loadServiceLeads();
  }

  Future<void> loadServiceLeads() async {
    try {
      if (kDebugMode) {
        print('DEBUG: loadServiceLeads started');
      }
      isLoading.value = true;
      error.value = '';

      if (kDebugMode) {
        print(
          'DEBUG: Calling use case with params - page: ${currentPage.value}, limit: ${limit.value}, search: "${searchQuery.value}"',
        );
      }

      final response = await _getServiceLeadsUseCase.execute(
        page: currentPage.value,
        limit: limit.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        serviceType: selectedServiceType.value.isEmpty
            ? null
            : selectedServiceType.value,
        startDate: startDate.value,
        endDate: endDate.value,
      );

      if (kDebugMode) {
        print(
          'DEBUG: Response received - serviceLeadData count: ${response.serviceLeadData.length}',
        );
      }

      serviceLeads.value = response.serviceLeadData;
      totalPages.value = response.totalPages;
      totalItems.value = response.totalItems;
      currentPage.value = response.currentPage;

      // Update counts
      totalCount.value = response.count.all;
      annualCount.value = response.count.annual;
      wgmCount.value = response.count.wgm;

      if (kDebugMode) {
        print('DEBUG: Data updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DEBUG: loadServiceLeads error: $e');
      }
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load service leads: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;

      if (kDebugMode) {
        print('DEBUG: loadServiceLeads completed');
      }
    }
  }

  Future<void> refreshServiceLeads() async {
    currentPage.value = 1;
    await loadServiceLeads();
  }

  void searchServiceLeads(String query) {
    if (kDebugMode) {
      print('DEBUG: searchServiceLeads called with query: "$query"');
    }
    searchQuery.value = query;
    currentPage.value = 1;
    _debounceSearch();
  }

  void _debounceSearch() {
    if (kDebugMode) {
      print('DEBUG: _debounceSearch called');
    }
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Create new timer
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (kDebugMode) {
        print(
          'DEBUG: Debounce timer triggered for query: "${searchQuery.value}"',
        );
      }
      if (searchQuery.value.length >= 2 || searchQuery.value.isEmpty) {
        if (kDebugMode) {
          print('DEBUG: Calling loadServiceLeads from debounce');
        }
        loadServiceLeads();
      } else {
        if (kDebugMode) {
          print('DEBUG: Query too short, not calling loadServiceLeads');
        }
      }
    });
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    loadServiceLeads();
  }

  void filterByServiceType(String serviceType) {
    selectedServiceType.value = serviceType;
    currentPage.value = 1;
    loadServiceLeads();
  }

  void filterByDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    currentPage.value = 1;
    loadServiceLeads();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      loadServiceLeads();
    }
  }

  void changeLimit(int newLimit) {
    limit.value = newLimit;
    currentPage.value = 1;
    loadServiceLeads();
  }

  Future<ServiceLead?> getServiceLeadById(String id) async {
    try {
      isLoading.value = true;
      final serviceLead = await _getServiceLeadByIdUseCase.execute(id);
      return serviceLead;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load service lead: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createServiceLead(ServiceLead serviceLead) async {
    try {
      isLoading.value = true;
      await _createServiceLeadUseCase.execute(serviceLead);
      Get.snackbar(
        'Success',
        'Service lead created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await refreshServiceLeads();
      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create service lead: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateServiceLead(String id, ServiceLead serviceLead) async {
    try {
      isLoading.value = true;
      await _updateServiceLeadUseCase.execute(id, serviceLead);
      Get.snackbar(
        'Success',
        'Service lead updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await refreshServiceLeads();
      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update service lead: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteServiceLead(String id) async {
    try {
      isLoading.value = true;
      await _deleteServiceLeadUseCase.execute(id);
      Get.snackbar(
        'Success',
        'Service lead deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await refreshServiceLeads();
      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete service lead: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedStatus.value = '';
    selectedServiceType.value = '';
    startDate.value = null;
    endDate.value = null;
    currentPage.value = 1;
    loadServiceLeads();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
