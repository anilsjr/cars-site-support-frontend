class ServiceTicket {
  final String id;
  final int serviceTicketId;
  final String serviceType;
  final String chassis;
  final int? fleetDoorNo;
  final int? estimateWorkHr;
  final DateTime campInDateTime;
  final DateTime? campExitDateTime;
  final String status;
  final DateTime createdOn;
  final String createdBy;
  final DateTime elapsedTime;
  final int version;

  const ServiceTicket({
    required this.id,
    required this.serviceTicketId,
    required this.serviceType,
    required this.chassis,
    this.fleetDoorNo,
    this.estimateWorkHr,
    required this.campInDateTime,
    this.campExitDateTime,
    required this.status,
    required this.createdOn,
    required this.createdBy,
    required this.elapsedTime,
    required this.version,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceTicket &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serviceTicketId == other.serviceTicketId;

  @override
  int get hashCode => id.hashCode ^ serviceTicketId.hashCode;

  @override
  String toString() {
    return 'ServiceTicket{id: $id, serviceTicketId: $serviceTicketId, serviceType: $serviceType, chassis: $chassis, fleetDoorNo: $fleetDoorNo, status: $status}';
  }
}
