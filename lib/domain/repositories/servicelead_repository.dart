import '../entities/servicelead.dart';

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

abstract class ServiceLeadRepository {
  Future<ServiceLeadResponse> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ServiceLead> getServiceLeadById(String id);

  Future<ServiceLead> createServiceLead(ServiceLead serviceLead);

  Future<ServiceLead> updateServiceLead(String id, ServiceLead serviceLead);

  Future<void> deleteServiceLead(String id);
}
