import '../entities/serviceticket.dart';
import '../repositories/serviceticket_repository.dart';

class GetServiceTicketsUseCase {
  final ServiceTicketRepository _repository;

  GetServiceTicketsUseCase(this._repository);

  Future<ServiceTicketResponse> execute({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _repository.getServiceTickets(
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

class GetServiceTicketByIdUseCase {
  final ServiceTicketRepository _repository;

  GetServiceTicketByIdUseCase(this._repository);

  Future<ServiceTicket> execute(String id) async {
    return await _repository.getServiceTicketById(id);
  }
}

class CreateServiceTicketUseCase {
  final ServiceTicketRepository _repository;

  CreateServiceTicketUseCase(this._repository);

  Future<ServiceTicket> execute(ServiceTicket serviceTicket) async {
    return await _repository.createServiceTicket(serviceTicket);
  }
}

class UpdateServiceTicketUseCase {
  final ServiceTicketRepository _repository;

  UpdateServiceTicketUseCase(this._repository);

  Future<ServiceTicket> execute(String id, ServiceTicket serviceTicket) async {
    return await _repository.updateServiceTicket(id, serviceTicket);
  }
}

class DeleteServiceTicketUseCase {
  final ServiceTicketRepository _repository;

  DeleteServiceTicketUseCase(this._repository);

  Future<void> execute(String id) async {
    await _repository.deleteServiceTicket(id);
  }
}
