import '../../domain/entities/serviceticket.dart';
import '../../domain/repositories/serviceticket_repository.dart';
import '../datasources/serviceticket_remote_datasource.dart';
import '../models/serviceticket_model.dart';

class ServiceTicketRepositoryImpl implements ServiceTicketRepository {
  final ServiceTicketRemoteDataSource _remoteDataSource;

  ServiceTicketRepositoryImpl({
    required ServiceTicketRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ServiceTicketResponse> getServiceTickets({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _remoteDataSource.getServiceTickets(
        page: page,
        limit: limit,
        search: search,
        status: status,
        serviceType: serviceType,
        startDate: startDate,
        endDate: endDate,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to get service Tickets: $e');
    }
  }

  @override
  Future<ServiceTicket> getServiceTicketById(String id) async {
    try {
      final result = await _remoteDataSource.getServiceTicketById(id);
      return result;
    } catch (e) {
      throw Exception('Failed to get service Ticket: $e');
    }
  }

  @override
  Future<ServiceTicket> createServiceTicket(ServiceTicket serviceTicket) async {
    try {
      final serviceTicketModel = ServiceTicketModel(
        id: serviceTicket.id,

        createdBy: serviceTicket.createdBy,

        serviceType: serviceTicket.serviceType,
        version: serviceTicket.version,
        serviceTicketId: serviceTicket.serviceTicketId,
        chassis: serviceTicket.chassis,
        campInDateTime: serviceTicket.campInDateTime,
        status: serviceTicket.status,
        createdOn: serviceTicket.createdOn,
        elapsedTime: serviceTicket.elapsedTime,
      );

      final result = await _remoteDataSource.createServiceTicket(
        serviceTicketModel,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to create service Ticket: $e');
    }
  }

  @override
  Future<ServiceTicket> updateServiceTicket(
    String id,
    ServiceTicket serviceTicket,
  ) async {
    try {
      final serviceTicketModel = ServiceTicketModel(
        id: serviceTicket.id,
        createdBy: serviceTicket.createdBy,
        serviceType: serviceTicket.serviceType,
        version: serviceTicket.version,
        serviceTicketId: serviceTicket.serviceTicketId,
        chassis: serviceTicket.chassis,
        campInDateTime: serviceTicket.campInDateTime,
        status: serviceTicket.status,
        createdOn: serviceTicket.createdOn,
        elapsedTime: serviceTicket.elapsedTime,
      );

      final result = await _remoteDataSource.updateServiceTicket(
        id,
        serviceTicketModel,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to update service Ticket: $e');
    }
  }

  @override
  Future<void> deleteServiceTicket(String id) async {
    try {
      await _remoteDataSource.deleteServiceTicket(id);
    } catch (e) {
      throw Exception('Failed to delete service Ticket: $e');
    }
  }
}
