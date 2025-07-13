import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/service_lead.dart';
import '../../domain/usecases/service_lead_usecases.dart';

class ServiceLeadsController extends GetxController {
  // Use cases
  final GetServiceLeadsUseCase _getServiceLeadsUseCase;

  ServiceLeadsController(this._getServiceLeadsUseCase);

  // Observable state
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<ServiceLeadResponse> serviceLeadsResponse =
      Rxn<ServiceLeadResponse>();

  // Pagination state
  final RxInt currentPage = 1.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;

  // Filter state
  final RxString searchQuery = ''.obs;
  final RxString selectedOrderType = ''.obs;
  final RxString selectedStatus = ''.obs;

  // Search controller
  final TextEditingController searchController = TextEditingController();

  // Available page sizes
  final List<int> pageSizeOptions = [5, 10, 25, 50];

  @override
  void onInit() {
    super.onInit();
    loadServiceLeads();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Load service leads with current pagination and filter settings
  Future<void> loadServiceLeads() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _getServiceLeadsUseCase.execute(
        page: currentPage.value,
        limit: pageSize.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        orderType: selectedOrderType.value.isNotEmpty
            ? selectedOrderType.value
            : null,
        status: selectedStatus.value.isNotEmpty ? selectedStatus.value : null,
      );

      serviceLeadsResponse.value = response;
      totalPages.value = response.totalPages;
      totalItems.value = response.totalItems;
    } catch (e) {
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
    }
  }

  /// Refresh data
  Future<void> refreshData() async {
    currentPage.value = 1;
    await loadServiceLeads();
  }

  /// Go to specific page
  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      currentPage.value = page;
      await loadServiceLeads();
    }
  }

  /// Go to next page
  Future<void> nextPage() async {
    if (currentPage.value < totalPages.value) {
      await goToPage(currentPage.value + 1);
    }
  }

  /// Go to previous page
  Future<void> previousPage() async {
    if (currentPage.value > 1) {
      await goToPage(currentPage.value - 1);
    }
  }

  /// Change page size
  Future<void> changePageSize(int newSize) async {
    if (pageSizeOptions.contains(newSize) && newSize != pageSize.value) {
      pageSize.value = newSize;
      currentPage.value = 1; // Reset to first page
      await loadServiceLeads();
    }
  }

  /// Apply search filter
  Future<void> applySearch(String query) async {
    searchQuery.value = query;
    currentPage.value = 1; // Reset to first page
    await loadServiceLeads();
  }

  /// Clear search
  Future<void> clearSearch() async {
    searchController.clear();
    searchQuery.value = '';
    currentPage.value = 1;
    await loadServiceLeads();
  }

  /// Apply order type filter
  Future<void> filterByOrderType(String orderType) async {
    selectedOrderType.value = orderType;
    currentPage.value = 1;
    await loadServiceLeads();
  }

  /// Apply status filter
  Future<void> filterByStatus(String status) async {
    selectedStatus.value = status;
    currentPage.value = 1;
    await loadServiceLeads();
  }

  /// Clear all filters
  Future<void> clearAllFilters() async {
    searchController.clear();
    searchQuery.value = '';
    selectedOrderType.value = '';
    selectedStatus.value = '';
    currentPage.value = 1;
    await loadServiceLeads();
  }

  // Helper getters
  List<ServiceLead> get serviceLeads =>
      serviceLeadsResponse.value?.serviceLeadData ?? [];
  bool get hasData => serviceLeads.isNotEmpty;
  bool get canGoNext => currentPage.value < totalPages.value;
  bool get canGoPrevious => currentPage.value > 1;
}
