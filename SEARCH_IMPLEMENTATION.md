# Search Feature Implementation Guide

## Overview

This document explains how the search feature is implemented in the ServiceLead screen of the Vehicle Site Support Web application.

## Key Features Implemented

### 1. **Real-time Search with Debouncing**

- **Location**: `ServiceLeadController.searchServiceLeads()`
- **Debounce Time**: 300ms
- **Minimum Characters**: 2 characters (or empty to clear)
- **Search Fields**: Chassis No, Door No, Registration No, Model No

### 2. **Advanced Filtering**

- **Status Filter**: Pending, In Progress, Completed, Cancelled
- **Service Type Filter**: All, Annual, WGM
- **Date Range Filter**: Start Date and End Date selection
- **Clear All Filters**: Reset all filters to default

### 3. **Server-side Pagination**

- **Page Size Options**: 5, 10, 25, 50
- **Navigation**: Previous/Next buttons
- **Information Display**: Shows "X-Y of Total" records

## Architecture

### Controller Layer (`ServiceLeadController`)

```dart
// Search with debouncing
void searchServiceLeads(String query) {
  searchQuery.value = query;
  currentPage.value = 1;
  _debounceSearch();
}

// Filter by status
void filterByStatus(String status) {
  selectedStatus.value = status;
  currentPage.value = 1;
  loadServiceLeads();
}

// Filter by service type
void filterByServiceType(String serviceType) {
  selectedServiceType.value = serviceType;
  currentPage.value = 1;
  loadServiceLeads();
}
```

### UI Layer (`ServiceLeadScreen`)

```dart
// Search text change handler
void _onSearchChanged() {
  _controller.searchServiceLeads(_searchController.text);
}

// Advanced filters dialog
void _showAdvancedFilters(BuildContext context) {
  // Status dropdown, date pickers, clear filters
}
```

## Search Flow

1. **User Input**: User types in search field
2. **Debouncing**: Controller waits 300ms for user to stop typing
3. **API Call**: If query ≥ 2 characters or empty, triggers `loadServiceLeads()`
4. **Server Processing**: Backend filters data based on search parameters
5. **UI Update**: Results displayed with pagination information

## Search Parameters Sent to Backend

```dart
final response = await _getServiceLeadsUseCase.execute(
  page: currentPage.value,
  limit: limit.value,
  search: searchQuery.value.isEmpty ? null : searchQuery.value,
  status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
  serviceType: selectedServiceType.value.isEmpty ? null : selectedServiceType.value,
  startDate: startDate.value,
  endDate: endDate.value,
);
```

## UI Components

### 1. **Search Bar**

- Input field with search icon
- Loading indicator during search
- Clear button when text is present
- Filter button for advanced options

### 2. **Tab Filters**

- All, Annual, WGM tabs
- Real-time count updates
- Integrated with service type filtering

### 3. **Advanced Filter Dialog**

- Status dropdown
- Date range pickers
- Clear all filters button

### 4. **Results Table**

- Responsive design
- Loading states
- Empty state handling

### 5. **Pagination Controls**

- Rows per page selector
- Page navigation
- Current page indicator

## Performance Optimizations

### 1. **Debouncing**

```dart
Timer? _debounceTimer;

void _debounceSearch() {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 300), () {
    if (searchQuery.value.length >= 2 || searchQuery.value.isEmpty) {
      loadServiceLeads();
    }
  });
}
```

### 2. **Server-side Processing**

- All filtering and pagination happens on the server
- Reduces client-side memory usage
- Faster response times for large datasets

### 3. **Reactive UI Updates**

- Uses GetX observables (`Rx` variables)
- Automatic UI updates when data changes
- Minimal rebuilds

## Error Handling

### 1. **Network Errors**

```dart
try {
  final response = await _getServiceLeadsUseCase.execute(...);
  // Process response
} catch (e) {
  error.value = e.toString();
  Get.snackbar('Error', 'Failed to load service leads: ${e.toString()}');
}
```

### 2. **Loading States**

- Loading indicator in search bar
- Loading spinner for table data
- Disabled controls during loading

### 3. **Empty States**

- "No service leads found" message
- Clear instructions for users

## Usage Examples

### Basic Search

```dart
// User types "ABC123" in search field
// After 300ms, search is triggered
_controller.searchServiceLeads("ABC123");
```

### Status Filtering

```dart
// Filter by completed status
_controller.filterByStatus("Completed");
```

### Date Range Filtering

```dart
// Filter by date range
_controller.filterByDateRange(
  DateTime(2024, 1, 1),
  DateTime(2024, 12, 31)
);
```

### Clear All Filters

```dart
_controller.clearFilters();
```

## Best Practices Implemented

1. **Separation of Concerns**: Search logic in controller, UI logic in screen
2. **Debouncing**: Prevents excessive API calls
3. **Server-side Filtering**: Better performance for large datasets
4. **Reactive Programming**: Automatic UI updates with GetX
5. **Error Handling**: Proper error states and user feedback
6. **Loading States**: Clear indication of ongoing operations
7. **Responsive Design**: Works on different screen sizes
8. **Accessibility**: Proper labels and keyboard navigation

## Future Enhancements

1. **Search Suggestions**: Auto-complete based on previous searches
2. **Saved Filters**: Allow users to save and reuse filter combinations
3. **Export Filtered Results**: Export search results to CSV/Excel
4. **Advanced Search Operators**: AND, OR, NOT operations
5. **Search History**: Remember recent searches
6. **Real-time Updates**: WebSocket integration for live data updates

## Testing the Search Feature

### Manual Testing

1. Type in search field and verify debouncing
2. Test all filter combinations
3. Verify pagination works with filters
4. Test clear filters functionality
5. Test responsive behavior on different screen sizes

### Unit Testing

```dart
// Test search debouncing
test('should debounce search queries', () async {
  controller.searchServiceLeads('test');
  controller.searchServiceLeads('test2');
  // Verify only the last search is executed
});

// Test filter combinations
test('should apply multiple filters', () {
  controller.filterByStatus('Completed');
  controller.searchServiceLeads('ABC');
  // Verify both filters are applied
});
```

This implementation provides a robust, performant, and user-friendly search experience for the ServiceLead management system.
