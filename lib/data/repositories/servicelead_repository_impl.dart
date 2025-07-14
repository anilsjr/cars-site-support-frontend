import '../../domain/entities/servicelead.dart';
import '../../domain/repositories/servicelead_repository.dart';
import '../datasources/servicelead_remote_datasource.dart';
import '../models/servicelead_model.dart';

class ServiceLeadRepositoryImpl implements ServiceLeadRepository {
  final ServiceLeadRemoteDataSource _remoteDataSource;

  ServiceLeadRepositoryImpl({
    required ServiceLeadRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ServiceLeadResponse> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _remoteDataSource.getServiceLeads(
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
      throw Exception('Failed to get service leads: $e');
    }
  }

  @override
  Future<ServiceLead> getServiceLeadById(String id) async {
    try {
      final result = await _remoteDataSource.getServiceLeadById(id);
      return result;
    } catch (e) {
      throw Exception('Failed to get service lead: $e');
    }
  }

  @override
  Future<ServiceLead> createServiceLead(ServiceLead serviceLead) async {
    try {
      final serviceLeadModel = ServiceLeadModel(
        id: serviceLead.id,
        numericId: serviceLead.numericId,
        orderType: serviceLead.orderType,
        modelId: serviceLead.modelId,
        modelNo: serviceLead.modelNo,
        doorNo: serviceLead.doorNo,
        vinNo: serviceLead.vinNo,
        chassisNo: serviceLead.chassisNo,
        registrationNo: serviceLead.registrationNo,
        scheduleDate: serviceLead.scheduleDate,
        estimateWorkhours: serviceLead.estimateWorkhours,
        leadStatus: serviceLead.leadStatus,
        rescheduledCount: serviceLead.rescheduledCount,
        isServiceTicketCreated: serviceLead.isServiceTicketCreated,
        remark: serviceLead.remark,
        externalSystemId: serviceLead.externalSystemId,
        dataSource: serviceLead.dataSource,
        createdBy: serviceLead.createdBy,
        createdAt: serviceLead.createdAt,
        updatedBy: serviceLead.updatedBy,
        updatedAt: serviceLead.updatedAt,
        deletedAt: serviceLead.deletedAt,
        plantCode: serviceLead.plantCode,
        serviceTypeId: serviceLead.serviceTypeId,
        isSelfCreated: serviceLead.isSelfCreated,
        serviceType: serviceLead.serviceType,
        version: serviceLead.version,
      );

      final result = await _remoteDataSource.createServiceLead(
        serviceLeadModel,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to create service lead: $e');
    }
  }

  @override
  Future<ServiceLead> updateServiceLead(
    String id,
    ServiceLead serviceLead,
  ) async {
    try {
      final serviceLeadModel = ServiceLeadModel(
        id: serviceLead.id,
        numericId: serviceLead.numericId,
        orderType: serviceLead.orderType,
        modelId: serviceLead.modelId,
        modelNo: serviceLead.modelNo,
        doorNo: serviceLead.doorNo,
        vinNo: serviceLead.vinNo,
        chassisNo: serviceLead.chassisNo,
        registrationNo: serviceLead.registrationNo,
        scheduleDate: serviceLead.scheduleDate,
        estimateWorkhours: serviceLead.estimateWorkhours,
        leadStatus: serviceLead.leadStatus,
        rescheduledCount: serviceLead.rescheduledCount,
        isServiceTicketCreated: serviceLead.isServiceTicketCreated,
        remark: serviceLead.remark,
        externalSystemId: serviceLead.externalSystemId,
        dataSource: serviceLead.dataSource,
        createdBy: serviceLead.createdBy,
        createdAt: serviceLead.createdAt,
        updatedBy: serviceLead.updatedBy,
        updatedAt: serviceLead.updatedAt,
        deletedAt: serviceLead.deletedAt,
        plantCode: serviceLead.plantCode,
        serviceTypeId: serviceLead.serviceTypeId,
        isSelfCreated: serviceLead.isSelfCreated,
        serviceType: serviceLead.serviceType,
        version: serviceLead.version,
      );

      final result = await _remoteDataSource.updateServiceLead(
        id,
        serviceLeadModel,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to update service lead: $e');
    }
  }

  @override
  Future<void> deleteServiceLead(String id) async {
    try {
      await _remoteDataSource.deleteServiceLead(id);
    } catch (e) {
      throw Exception('Failed to delete service lead: $e');
    }
  }
}
