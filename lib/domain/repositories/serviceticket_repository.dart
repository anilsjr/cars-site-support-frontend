import '../entities/serviceticket.dart';

class ServiceTicketResponse {
  final bool status;
  final int statusCode;
  final String statusMessage;
  final List<ServiceTicket> serviceTicketData;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int limit;
  final ServiceTicketCount count;

  const ServiceTicketResponse({
    required this.status,
    required this.statusCode,
    required this.statusMessage,
    required this.serviceTicketData,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.count,
  });
}

class ServiceTicketCount {
  final int all;
  final int inprogress;
  final int wgm;
  final int completed;

  const ServiceTicketCount({
    required this.all,
    required this.inprogress,
    required this.wgm,
    required this.completed,
  });
}

abstract class ServiceTicketRepository {
  Future<ServiceTicketResponse> getServiceTickets({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ServiceTicket> getServiceTicketById(String id);

  Future<ServiceTicket> createServiceTicket(ServiceTicket serviceTicket);

  Future<ServiceTicket> updateServiceTicket(
    String id,
    ServiceTicket serviceTicket,
  );

  Future<void> deleteServiceTicket(String id);
}
