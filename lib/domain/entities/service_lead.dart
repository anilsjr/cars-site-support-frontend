class ServiceLead {
  final String id;
  final String orderType;
  final String? customerName;
  final String? vehicleNumber;
  final String? contactNumber;
  final String? serviceType;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? additionalData;

  const ServiceLead({
    required this.id,
    required this.orderType,
    this.customerName,
    this.vehicleNumber,
    this.contactNumber,
    this.serviceType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.additionalData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceLead &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ServiceLead{id: $id, orderType: $orderType, customerName: $customerName}';
  }
}

class ServiceLeadResponse {
  final bool status;
  final int statusCode;
  final String statusMessage;
  final List<ServiceLead> serviceLeadData;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int limit;
  final ServiceLeadCount count;

  const ServiceLeadResponse({
    required this.status,
    required this.statusCode,
    required this.statusMessage,
    required this.serviceLeadData,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.count,
  });
}

class ServiceLeadCount {
  final int all;
  final int annual;
  final int wgm;

  const ServiceLeadCount({
    required this.all,
    required this.annual,
    required this.wgm,
  });
}
