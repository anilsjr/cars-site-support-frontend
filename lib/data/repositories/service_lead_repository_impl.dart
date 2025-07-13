import '../../domain/entities/service_lead.dart';
import '../../domain/repositories/service_lead_repository.dart';
import '../datasources/service_lead_remote_datasource.dart';

class ServiceLeadRepositoryImpl implements ServiceLeadRepository {
  final ServiceLeadRemoteDataSource remoteDataSource;

  ServiceLeadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ServiceLeadResponse> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? orderType,
    String? status,
  }) async {
    try {
      final response = await remoteDataSource.getServiceLeads(
        page: page,
        limit: limit,
        search: search,
        orderType: orderType,
        status: status,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get service leads: $e');
    }
  }

  @override
  Future<ServiceLead> getServiceLeadById(String id) async {
    try {
      final model = await remoteDataSource.getServiceLeadById(id);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get service lead: $e');
    }
  }
}
