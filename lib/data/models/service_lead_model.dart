import '../../domain/entities/service_lead.dart';

class ServiceLeadModel extends ServiceLead {
  const ServiceLeadModel({
    required super.id,
    required super.orderType,
    super.customerName,
    super.vehicleNumber,
    super.contactNumber,
    super.serviceType,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.additionalData,
  });

  factory ServiceLeadModel.fromJson(Map<String, dynamic> json) {
    return ServiceLeadModel(
      id: json['_id'] ?? '',
      orderType: json['order_type'] ?? '',
      customerName: json['customer_name'],
      vehicleNumber: json['vehicle_number'],
      contactNumber: json['contact_number'],
      serviceType: json['service_type'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      additionalData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'order_type': orderType,
      'customer_name': customerName,
      'vehicle_number': vehicleNumber,
      'contact_number': contactNumber,
      'service_type': serviceType,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      ...?additionalData,
    };
  }

  ServiceLead toEntity() {
    return ServiceLead(
      id: id,
      orderType: orderType,
      customerName: customerName,
      vehicleNumber: vehicleNumber,
      contactNumber: contactNumber,
      serviceType: serviceType,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      additionalData: additionalData,
    );
  }
}

class ServiceLeadResponseModel extends ServiceLeadResponse {
  const ServiceLeadResponseModel({
    required super.status,
    required super.statusCode,
    required super.statusMessage,
    required super.serviceLeadData,
    required super.totalItems,
    required super.totalPages,
    required super.currentPage,
    required super.limit,
    required super.count,
  });

  factory ServiceLeadResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceLeadResponseModel(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      statusMessage: json['status_message'] ?? '',
      serviceLeadData:
          (json['serviceLeadData'] as List<dynamic>?)
              ?.map((item) => ServiceLeadModel.fromJson(item))
              .toList() ??
          [],
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      limit: json['limit'] ?? 10,
      count: ServiceLeadCountModel.fromJson(json['count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'status_message': statusMessage,
      'serviceLeadData': serviceLeadData
          .map((lead) => (lead as ServiceLeadModel).toJson())
          .toList(),
      'totalItems': totalItems,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'limit': limit,
      'count': (count as ServiceLeadCountModel).toJson(),
    };
  }
}

class ServiceLeadCountModel extends ServiceLeadCount {
  const ServiceLeadCountModel({
    required super.all,
    required super.annual,
    required super.wgm,
  });

  factory ServiceLeadCountModel.fromJson(Map<String, dynamic> json) {
    return ServiceLeadCountModel(
      all: json['all'] ?? 0,
      annual: json['annual'] ?? 0,
      wgm: json['wgm'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'all': all, 'annual': annual, 'wgm': wgm};
  }
}
