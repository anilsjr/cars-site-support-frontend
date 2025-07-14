import '../entities/servicelead.dart';
import '../repositories/servicelead_repository.dart';

class GetServiceLeadsUseCase {
  final ServiceLeadRepository _repository;

  GetServiceLeadsUseCase(this._repository);

  Future<ServiceLeadResponse> execute({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _repository.getServiceLeads(
      page: page,
      limit: limit,
      search: search,
      status: status,
      serviceType: serviceType,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetServiceLeadByIdUseCase {
  final ServiceLeadRepository _repository;

  GetServiceLeadByIdUseCase(this._repository);

  Future<ServiceLead> execute(String id) async {
    return await _repository.getServiceLeadById(id);
  }
}

class CreateServiceLeadUseCase {
  final ServiceLeadRepository _repository;

  CreateServiceLeadUseCase(this._repository);

  Future<ServiceLead> execute(ServiceLead serviceLead) async {
    return await _repository.createServiceLead(serviceLead);
  }
}

class UpdateServiceLeadUseCase {
  final ServiceLeadRepository _repository;

  UpdateServiceLeadUseCase(this._repository);

  Future<ServiceLead> execute(String id, ServiceLead serviceLead) async {
    return await _repository.updateServiceLead(id, serviceLead);
  }
}

class DeleteServiceLeadUseCase {
  final ServiceLeadRepository _repository;

  DeleteServiceLeadUseCase(this._repository);

  Future<void> execute(String id) async {
    await _repository.deleteServiceLead(id);
  }
}
