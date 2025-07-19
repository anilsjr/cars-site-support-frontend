import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../models/serviceticket_model.dart';

abstract class ServiceTicketRemoteDataSource {
  Future<ServiceTicketResponseModel> getServiceTickets({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? serviceType,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ServiceTicketModel> getServiceTicketById(String id);
  Future<ServiceTicketModel> createServiceTicket(
    ServiceTicketModel ServiceTicket,
  );
  Future<ServiceTicketModel> updateServiceTicket(
    String id,
    ServiceTicketModel ServiceTicket,
  );
  Future<void> deleteServiceTicket(String id);
}

class ServiceTicketRemoteDataSourceImpl
    implements ServiceTicketRemoteDataSource {
  final NetworkService _networkService;

  ServiceTicketRemoteDataSourceImpl({NetworkService? networkService})
    : _networkService = networkService ?? NetworkService();

  @override
  Future<ServiceTicketResponseModel> getServiceTickets({
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
        '/api/ServiceTicket/view',
        queryParameters: queryParams,
      );

      return ServiceTicketResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service leads: $e');
    }
  }

  @override
  Future<ServiceTicketModel> getServiceTicketById(String id) async {
    try {
      final response = await _networkService.get('/api/ServiceTicket/view/$id');

      return ServiceTicketModel.fromJson(response.data['ServiceTicket']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to fetch service lead: $e');
    }
  }

  @override
  Future<ServiceTicketModel> createServiceTicket(
    ServiceTicketModel ServiceTicket,
  ) async {
    try {
      final response = await _networkService.post(
        '/api/ServiceTicket/create',
        data: ServiceTicket.toJson(),
      );

      return ServiceTicketModel.fromJson(response.data['ServiceTicket']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to create service lead: $e');
    }
  }

  @override
  Future<ServiceTicketModel> updateServiceTicket(
    String id,
    ServiceTicketModel ServiceTicket,
  ) async {
    try {
      final response = await _networkService.put(
        '/api/ServiceTicket/update/$id',
        data: ServiceTicket.toJson(),
      );

      return ServiceTicketModel.fromJson(response.data['ServiceTicket']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Failed to update service lead: $e');
    }
  }

  @override
  Future<void> deleteServiceTicket(String id) async {
    try {
      await _networkService.delete('/api/ServiceTicket/delete/$id');
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
