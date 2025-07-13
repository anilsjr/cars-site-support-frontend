import '../entities/service_lead.dart';
import '../repositories/service_lead_repository.dart';

class GetServiceLeadsUseCase {
  final ServiceLeadRepository repository;

  GetServiceLeadsUseCase(this.repository);

  Future<ServiceLeadResponse> execute({
    int page = 1,
    int limit = 10,
    String? search,
    String? orderType,
    String? status,
  }) async {
    if (page < 1) {
      throw ArgumentError('Page must be greater than 0');
    }
    if (limit < 1 || limit > 100) {
      throw ArgumentError('Limit must be between 1 and 100');
    }

    return await repository.getServiceLeads(
      page: page,
      limit: limit,
      search: search,
      orderType: orderType,
      status: status,
    );
  }
}

class GetServiceLeadByIdUseCase {
  final ServiceLeadRepository repository;

  GetServiceLeadByIdUseCase(this.repository);

  Future<ServiceLead> execute(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Service lead ID cannot be empty');
    }

    return await repository.getServiceLeadById(id);
  }
}
