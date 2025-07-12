import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataListController extends GetxController {
  final searchController = TextEditingController();
  final RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredData =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Demo data
      final demoData = [
        {
          'id': 1,
          'title': 'Vehicle Registration',
          'description': 'Registration details for vehicle ABC123',
          'date': '2025-01-10',
        },
        {
          'id': 2,
          'title': 'Maintenance Record',
          'description': 'Oil change and tire rotation for vehicle XYZ789',
          'date': '2025-01-09',
        },
        {
          'id': 3,
          'title': 'Insurance Claim',
          'description': 'Insurance claim for minor accident',
          'date': '2025-01-08',
        },
        {
          'id': 4,
          'title': 'Inspection Report',
          'description': 'Annual safety inspection completed',
          'date': '2025-01-07',
        },
        {
          'id': 5,
          'title': 'Fuel Purchase',
          'description': 'Gas station purchase - Station A',
          'date': '2025-01-06',
        },
      ];

      data.value = demoData;
      filteredData.value = demoData;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData.value = data;
    } else {
      filteredData.value = data.where((item) {
        final title = item['title']?.toLowerCase() ?? '';
        final description = item['description']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return title.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
    }
  }

  Future<void> refreshData() async {
    await loadData();
    Get.snackbar(
      'Success',
      'Data refreshed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addNewItem() {
    Get.snackbar(
      'Info',
      'Add new item functionality to be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void editItem(Map<String, dynamic> item) {
    Get.snackbar(
      'Info',
      'Edit item: ${item['title']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteItem(Map<String, dynamic> item) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete "${item['title']}"?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        data.remove(item);
        filteredData.remove(item);
        Get.back();
        Get.snackbar(
          'Success',
          'Item deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void viewItem(Map<String, dynamic> item) {
    Get.snackbar(
      'Item Details',
      'Title: ${item['title']}\nDescription: ${item['description']}\nDate: ${item['date']}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
