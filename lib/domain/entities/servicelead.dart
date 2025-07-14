class ServiceLead {
  final String id;
  final int numericId;
  final String orderType;
  final int? modelId;
  final String modelNo;
  final String doorNo;
  final String vinNo;
  final String chassisNo;
  final String registrationNo;
  final DateTime scheduleDate;
  final int? estimateWorkhours;
  final String leadStatus;
  final int rescheduledCount;
  final bool isServiceTicketCreated;
  final String remark;
  final String? externalSystemId;
  final String dataSource;
  final DateTime createdBy;
  final DateTime createdAt;
  final DateTime? updatedBy;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String plantCode;
  final int serviceTypeId;
  final bool isSelfCreated;
  final String serviceType;
  final int? version;

  const ServiceLead({
    required this.id,
    required this.numericId,
    required this.orderType,
    this.modelId,
    required this.modelNo,
    required this.doorNo,
    required this.vinNo,
    required this.chassisNo,
    required this.registrationNo,
    required this.scheduleDate,
    this.estimateWorkhours,
    required this.leadStatus,
    required this.rescheduledCount,
    required this.isServiceTicketCreated,
    required this.remark,
    this.externalSystemId,
    required this.dataSource,
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    required this.updatedAt,
    this.deletedAt,
    required this.plantCode,
    required this.serviceTypeId,
    required this.isSelfCreated,
    required this.serviceType,
    this.version,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceLead &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          numericId == other.numericId;

  @override
  int get hashCode => id.hashCode ^ numericId.hashCode;

  @override
  String toString() {
    return 'ServiceLead{id: $id, numericId: $numericId, orderType: $orderType, modelNo: $modelNo, registrationNo: $registrationNo, leadStatus: $leadStatus}';
  }
}
