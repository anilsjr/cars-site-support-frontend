import '../../domain/entities/serviceticket.dart';
import '../../domain/repositories/serviceticket_repository.dart';

class ServiceTicketModel extends ServiceTicket {
  const ServiceTicketModel({
    required super.id,
    required super.serviceTicketId,
    required super.serviceType,
    required super.chassis,
    super.fleetDoorNo,
    super.estimateWorkHr,
    required super.campInDateTime,
    super.campExitDateTime,
    required super.status,
    required super.createdOn,
    required super.createdBy,
    required super.elapsedTime,
    required super.version,
  });

  factory ServiceTicketModel.fromJson(Map<String, dynamic> json) {
    return ServiceTicketModel(
      id: json['_id']?.toString() ?? '',
      serviceTicketId: json['serviceTicketId']?.toInt() ?? 0,
      serviceType: json['serviceType']?.toString() ?? '',
      chassis: json['chassis']?.toString() ?? '',
      fleetDoorNo: json['fleetDoorNo']?.toInt(),
      estimateWorkHr: json['estimateWorkHr']?.toInt(),
      campInDateTime: DateTime.parse(
        json['campInDateTime'] ?? DateTime.now().toIso8601String(),
      ),
      campExitDateTime: json['campExitDateTime'] != null
          ? DateTime.parse(json['campExitDateTime'])
          : null,
      status: json['status']?.toString() ?? '',
      createdOn: DateTime.parse(
        json['createdOn'] ?? DateTime.now().toIso8601String(),
      ),
      createdBy: json['createdBy']?.toString() ?? '',
      elapsedTime: DateTime.parse(
        json['elapsedTime'] ?? DateTime.now().toIso8601String(),
      ),
      version: json['__v']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceTicketId': serviceTicketId,
      'serviceType': serviceType,
      'chassis': chassis,
      'fleetDoorNo': fleetDoorNo,
      'estimateWorkHr': estimateWorkHr,
      'campInDateTime': campInDateTime.toIso8601String(),
      'campExitDateTime': campExitDateTime?.toIso8601String(),
      'status': status,
      'createdOn': createdOn.toIso8601String(),
      'createdBy': createdBy,
      'elapsedTime': elapsedTime.toIso8601String(),
      '__v': version,
    };
  }
}

class ServiceTicketResponseModel extends ServiceTicketResponse {
  const ServiceTicketResponseModel({
    required super.status,
    required super.statusCode,
    required super.statusMessage,
    required super.serviceTicketData,
    required super.totalItems,
    required super.totalPages,
    required super.currentPage,
    required super.limit,
    required super.count,
  });

  factory ServiceTicketResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceTicketResponseModel(
      status: json['status'] ?? false,
      statusCode: json['status_code']?.toInt() ?? 200,
      statusMessage: json['status_message']?.toString() ?? '',
      serviceTicketData: json['serviceTicketData'] != null
          ? (json['serviceTicketData'] as List)
                .map((item) => ServiceTicketModel.fromJson(item))
                .toList()
          : [],
      totalItems: json['totalItems']?.toInt() ?? 0,
      totalPages: json['totalPages']?.toInt() ?? 0,
      currentPage: json['currentPage']?.toInt() ?? 1,
      limit: json['limit']?.toInt() ?? 10,
      count: ServiceTicketCountModel.fromJson(json['count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'status_message': statusMessage,
      'serviceTicketData': serviceTicketData
          .map(
            (serviceTicket) => (serviceTicket as ServiceTicketModel).toJson(),
          )
          .toList(),
      'totalItems': totalItems,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'limit': limit,
      'count': (count as ServiceTicketCountModel).toJson(),
    };
  }
}

class ServiceTicketCountModel extends ServiceTicketCount {
  const ServiceTicketCountModel({
    required super.all,
    required super.inprogress,
    required super.wgm,
    required super.completed,
  });

  factory ServiceTicketCountModel.fromJson(Map<String, dynamic> json) {
    return ServiceTicketCountModel(
      all: json['all']?.toInt() ?? 0,
      inprogress: json['inprogress']?.toInt() ?? 0,
      wgm: json['wgm']?.toInt() ?? 0,
      completed: json['completed']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
      'inprogress': inprogress,
      'wgm': wgm,
      'completed': completed,
    };
  }
}
