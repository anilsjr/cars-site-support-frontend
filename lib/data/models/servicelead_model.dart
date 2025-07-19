import '../../domain/entities/servicelead.dart';
import '../../domain/repositories/servicelead_repository.dart';

class ServiceLeadModel extends ServiceLead {
  const ServiceLeadModel({
    required super.id,
    required super.numericId,
    required super.orderType,
    super.modelId,
    required super.modelNo,
    required super.doorNo,
    required super.vinNo,
    required super.chassisNo,
    required super.registrationNo,
    required super.scheduleDate,
    super.estimateWorkhours,
    required super.leadStatus,
    required super.rescheduledCount,
    required super.isServiceTicketCreated,
    required super.remark,
    super.externalSystemId,
    required super.dataSource,
    required super.createdBy,
    required super.createdAt,
    super.updatedBy,
    required super.updatedAt,
    super.deletedAt,
    required super.plantCode,
    required super.serviceTypeId,
    required super.isSelfCreated,
    required super.serviceType,
    super.version,
  });

  factory ServiceLeadModel.fromJson(Map<String, dynamic> json) {
    return ServiceLeadModel(
      id: json['_id']?.toString() ?? '',
      numericId: json['id']?.toInt() ?? 0,
      orderType: json['order_type']?.toString() ?? '',
      modelId: json['model_id']?.toInt(),
      modelNo: json['model_no']?.toString() ?? '',
      doorNo: json['door_no']?.toString() ?? '',
      vinNo: json['vin_no']?.toString() ?? '',
      chassisNo: json['chassis_no']?.toString() ?? '',
      registrationNo: json['registration_no']?.toString() ?? '',
      scheduleDate: DateTime.parse(
        json['schedule_date'] ?? DateTime.now().toIso8601String(),
      ),
      estimateWorkhours: json['estimate_workhours']?.toInt(),
      leadStatus: json['lead_status']?.toString() ?? '',
      rescheduledCount: json['rescheduled_count']?.toInt() ?? 0,
      isServiceTicketCreated: json['is_service_ticket_created'] ?? false,
      remark: json['remark']?.toString() ?? '',
      externalSystemId: json['external_system_id']?.toString(),
      dataSource: json['data_source']?.toString() ?? '',
      createdBy: DateTime.parse(
        json['created_by'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedBy: json['updated_by'] != null
          ? DateTime.parse(json['updated_by'])
          : null,
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      plantCode: json['plant_code']?.toString() ?? '',
      serviceTypeId: json['service_type_id']?.toInt() ?? 0,
      isSelfCreated: json['is_self_created'] ?? false,
      serviceType: json['service_type']?.toString() ?? '',
      version: json['__v']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': numericId,
      'order_type': orderType,
      'model_id': modelId,
      'model_no': modelNo,
      'door_no': doorNo,
      'vin_no': vinNo,
      'chassis_no': chassisNo,
      'registration_no': registrationNo,
      'schedule_date': scheduleDate.toIso8601String(),
      'estimate_workhours': estimateWorkhours,
      'lead_status': leadStatus,
      'rescheduled_count': rescheduledCount,
      'is_service_ticket_created': isServiceTicketCreated,
      'remark': remark,
      'external_system_id': externalSystemId,
      'data_source': dataSource,
      'created_by': createdBy.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_by': updatedBy?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'plant_code': plantCode,
      'service_type_id': serviceTypeId,
      'is_self_created': isSelfCreated,
      'service_type': serviceType,
      '__v': version,
    };
  }

  // ServiceLeadModel copyWith({
  //   String? id,
  //   int? numericId,
  //   String? orderType,
  //   int? modelId,
  //   String? modelNo,
  //   String? doorNo,
  //   String? vinNo,
  //   String? chassisNo,
  //   String? registrationNo,
  //   DateTime? scheduleDate,
  //   int? estimateWorkhours,
  //   String? leadStatus,
  //   int? rescheduledCount,
  //   bool? isServiceTicketCreated,
  //   String? remark,
  //   String? externalSystemId,
  //   String? dataSource,
  //   DateTime? createdBy,
  //   DateTime? createdAt,
  //   DateTime? updatedBy,
  //   DateTime? updatedAt,
  //   DateTime? deletedAt,
  //   String? plantCode,
  //   int? serviceTypeId,
  //   bool? isSelfCreated,
  //   String? serviceType,
  //   int? version,
  // }) {
  //   return ServiceLeadModel(
  //     id: id ?? this.id,
  //     numericId: numericId ?? this.numericId,
  //     orderType: orderType ?? this.orderType,
  //     modelId: modelId ?? this.modelId,
  //     modelNo: modelNo ?? this.modelNo,
  //     doorNo: doorNo ?? this.doorNo,
  //     vinNo: vinNo ?? this.vinNo,
  //     chassisNo: chassisNo ?? this.chassisNo,
  //     registrationNo: registrationNo ?? this.registrationNo,
  //     scheduleDate: scheduleDate ?? this.scheduleDate,
  //     estimateWorkhours: estimateWorkhours ?? this.estimateWorkhours,
  //     leadStatus: leadStatus ?? this.leadStatus,
  //     rescheduledCount: rescheduledCount ?? this.rescheduledCount,
  //     isServiceTicketCreated:
  //         isServiceTicketCreated ?? this.isServiceTicketCreated,
  //     remark: remark ?? this.remark,
  //     externalSystemId: externalSystemId ?? this.externalSystemId,
  //     dataSource: dataSource ?? this.dataSource,
  //     createdBy: createdBy ?? this.createdBy,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedBy: updatedBy ?? this.updatedBy,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     deletedAt: deletedAt ?? this.deletedAt,
  //     plantCode: plantCode ?? this.plantCode,
  //     serviceTypeId: serviceTypeId ?? this.serviceTypeId,
  //     isSelfCreated: isSelfCreated ?? this.isSelfCreated,
  //     serviceType: serviceType ?? this.serviceType,
  //     version: version ?? this.version,
  //   );
  // }
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
      statusCode: json['status_code']?.toInt() ?? 200,
      statusMessage: json['status_message']?.toString() ?? '',
      serviceLeadData: json['serviceLeadData'] != null
          ? (json['serviceLeadData'] as List)
                .map((item) => ServiceLeadModel.fromJson(item))
                .toList()
          : [],
      totalItems: json['totalItems']?.toInt() ?? 0,
      totalPages: json['totalPages']?.toInt() ?? 0,
      currentPage: json['currentPage']?.toInt() ?? 1,
      limit: json['limit']?.toInt() ?? 10,
      count: ServiceLeadCountModel.fromJson(json['count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'status_message': statusMessage,
      'serviceLeadData': serviceLeadData
          .map((serviceLead) => (serviceLead as ServiceLeadModel).toJson())
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
      all: json['all']?.toInt() ?? 0,
      annual: json['annual']?.toInt() ?? 0,
      wgm: json['wgm']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'all': all, 'annual': annual, 'wgm': wgm};
  }
}
