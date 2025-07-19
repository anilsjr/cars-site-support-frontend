import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/entities/serviceticket.dart';
import '../../domain/usecases/serviceticket_usecases.dart';

class ServiceTicketController extends GetxController {
  final GetServiceTicketsUseCase _getServiceTicketsUseCase;
  final GetServiceTicketByIdUseCase _getServiceTicketByIdUseCase;
  final CreateServiceTicketUseCase _createServiceTicketUseCase;
  final UpdateServiceTicketUseCase _updateServiceTicketUseCase;
  final DeleteServiceTicketUseCase _deleteServiceTicketUseCase;

  ServiceTicketController({
    required GetServiceTicketsUseCase getServiceTicketsUseCase,
    required GetServiceTicketByIdUseCase getServiceTicketByIdUseCase,
    required CreateServiceTicketUseCase createServiceTicketUseCase,
    required UpdateServiceTicketUseCase updateServiceTicketUseCase,
    required DeleteServiceTicketUseCase deleteServiceTicketUseCase,
  }) : _getServiceTicketsUseCase = getServiceTicketsUseCase,
       _getServiceTicketByIdUseCase = getServiceTicketByIdUseCase,
       _createServiceTicketUseCase = createServiceTicketUseCase,
       _updateServiceTicketUseCase = updateServiceTicketUseCase,
       _deleteServiceTicketUseCase = deleteServiceTicketUseCase;

  // Observable variables
  final RxList<ServiceTicket> serviceTickets = <ServiceTicket>[].obs;
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
  final RxInt inProgressCount = 0.obs;
  final RxInt completedCount = 0.obs;

  // Search debouncing
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    loadServiceTickets();
  }

  Future<void> loadServiceTickets() async {
    try {
      if (kDebugMode) {
        print('DEBUG: loadServiceTickets started');
      }
      isLoading.value = true;
      error.value = '';

      if (kDebugMode) {
        print(
          'DEBUG: Calling use case with params - page: ${currentPage.value}, limit: ${limit.value}, search: "${searchQuery.value}"',
        );
      }

      final response = await _getServiceTicketsUseCase.execute(
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
          'DEBUG: Response received - serviceTicketData count: ${response.serviceTicketData.length}',
        );
      }

      serviceTickets.value = response.serviceTicketData;
      totalPages.value = response.totalPages;
      totalItems.value = response.totalItems;
      currentPage.value = response.currentPage;

      // Update counts
      totalCount.value = response.count.all;
      inProgressCount.value = response.count.inprogress;
      completedCount.value = response.count.completed;
      wgmCount.value = response.count.wgm;

      if (kDebugMode) {
        print('DEBUG: Data updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DEBUG: loadServiceTickets error: $e');
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
        print('DEBUG: loadServiceTickets completed');
      }
    }
  }

  Future<void> refreshServiceTickets() async {
    currentPage.value = 1;
    await loadServiceTickets();
  }

  void searchServiceTickets(String query) {
    if (kDebugMode) {
      print('DEBUG: searchServiceTickets called with query: "$query"');
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
          print('DEBUG: Calling loadServiceTickets from debounce');
        }
        loadServiceTickets();
      } else {
        if (kDebugMode) {
          print('DEBUG: Query too short, not calling loadServiceTickets');
        }
      }
    });
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    loadServiceTickets();
  }

  void filterByServiceType(String serviceType) {
    selectedServiceType.value = serviceType;
    currentPage.value = 1;
    loadServiceTickets();
  }

  void filterByDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    currentPage.value = 1;
    loadServiceTickets();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      loadServiceTickets();
    }
  }

  void changeLimit(int newLimit) {
    limit.value = newLimit;
    currentPage.value = 1;
    loadServiceTickets();
  }

  Future<ServiceTicket?> getServiceTicketById(String id) async {
    try {
      isLoading.value = true;
      final serviceTicket = await _getServiceTicketByIdUseCase.execute(id);
      return serviceTicket;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load service ticket: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createServiceTicket(ServiceTicket serviceTicket) async {
    try {
      isLoading.value = true;
      await _createServiceTicketUseCase.execute(serviceTicket);
      Get.snackbar(
        'Success',
        'Service lead created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await refreshServiceTickets();
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

  Future<bool> updateServiceTicket(
    String id,
    ServiceTicket serviceTicket,
  ) async {
    try {
      isLoading.value = true;
      await _updateServiceTicketUseCase.execute(id, serviceTicket);
      Get.snackbar(
        'Success',
        'Service lead updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await refreshServiceTickets();
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

  Future<bool> deleteServiceTicket(String id) async {
    try {
      isLoading.value = true;
      await _deleteServiceTicketUseCase.execute(id);
      Get.snackbar(
        'Success',
        'Service ticket deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await refreshServiceTickets();
      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete service ticket: ${e.toString()}',
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
    loadServiceTickets();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
