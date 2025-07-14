import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../models/servicelead_model.dart';

abstract class ServiceLeadRemoteDataSource {
  Future<ServiceLeadResponseModel> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ServiceLeadModel> getServiceLeadById(String id);
  Future<ServiceLeadModel> createServiceLead(ServiceLeadModel serviceLead);
  Future<ServiceLeadModel> updateServiceLead(
    String id,
    ServiceLeadModel serviceLead,
  );
  Future<void> deleteServiceLead(String id);
}

class ServiceLeadRemoteDataSourceImpl implements ServiceLeadRemoteDataSource {
  final NetworkService _networkService;

  ServiceLeadRemoteDataSourceImpl({NetworkService? networkService})
    : _networkService = networkService ?? NetworkService();

  @override
  Future<ServiceLeadResponseModel> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (serviceType != null && serviceType.isNotEmpty) {
        queryParams['serviceType'] = serviceType;
      }
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _networkService.get(
        '/api/servicelead/view',
        queryParameters: queryParams,
      );

      return ServiceLeadResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service leads: $e');
    }
  }

  @override
  Future<ServiceLeadModel> getServiceLeadById(String id) async {
    try {
      final response = await _networkService.get('/api/servicelead/view/$id');

      return ServiceLeadModel.fromJson(response.data['serviceLead']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service lead: $e');
    }
  }

  @override
  Future<ServiceLeadModel> createServiceLead(
    ServiceLeadModel serviceLead,
  ) async {
    try {
      final response = await _networkService.post(
        '/api/servicelead/create',
        data: serviceLead.toJson(),
      );

      return ServiceLeadModel.fromJson(response.data['serviceLead']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to create service lead: $e');
    }
  }

  @override
  Future<ServiceLeadModel> updateServiceLead(
    String id,
    ServiceLeadModel serviceLead,
  ) async {
    try {
      final response = await _networkService.put(
        '/api/servicelead/update/$id',
        data: serviceLead.toJson(),
      );

      return ServiceLeadModel.fromJson(response.data['serviceLead']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to update service lead: $e');
    }
  }

  @override
  Future<void> deleteServiceLead(String id) async {
    try {
      await _networkService.delete('/api/servicelead/delete/$id');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to delete service lead: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection error');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
