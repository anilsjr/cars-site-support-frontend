import '../entities/service_lead.dart';

abstract class ServiceLeadRepository {
  /// Fetch service leads with pagination
  Future<ServiceLeadResponse> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? orderType,
    String? status,
  });

  /// Get a specific service lead by ID
  Future<ServiceLead> getServiceLeadById(String id);
}
