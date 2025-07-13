import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../models/service_lead_model.dart';

abstract class ServiceLeadRemoteDataSource {
  Future<ServiceLeadResponseModel> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? orderType,
    String? status,
  });

  Future<ServiceLeadModel> getServiceLeadById(String id);
}

class ServiceLeadRemoteDataSourceImpl implements ServiceLeadRemoteDataSource {
  final NetworkService networkService;

  ServiceLeadRemoteDataSourceImpl(this.networkService);

  @override
  Future<ServiceLeadResponseModel> getServiceLeads({
    int page = 1,
    int limit = 10,
    String? search,
    String? orderType,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'page': page, 'limit': limit};

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (orderType != null && orderType.isNotEmpty) {
        queryParameters['order_type'] = orderType;
      }
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await networkService.dio.get(
        '/api/servicelead/view',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return ServiceLeadResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch service leads',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Service leads not found');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ServiceLeadModel> getServiceLeadById(String id) async {
    try {
      final response = await networkService.dio.get('/api/servicelead/$id');

      if (response.statusCode == 200) {
        return ServiceLeadModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch service lead',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Service lead not found');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
