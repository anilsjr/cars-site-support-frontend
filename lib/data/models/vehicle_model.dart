import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.licensePlate,
    required super.make,
    required super.model,
    required super.year,
    required super.color,
    required super.vin,
    required super.ownerId,
    required super.registrationDate,
    super.inspectionDate,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id']?.toString() ?? '',
      licensePlate: json['license_plate']?.toString() ?? '',
      make: json['make']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: int.tryParse(json['year']?.toString() ?? '0') ?? 0,
      color: json['color']?.toString() ?? '',
      vin: json['vin']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      registrationDate: DateTime.parse(
        json['registration_date'] ?? DateTime.now().toIso8601String(),
      ),
      inspectionDate: json['inspection_date'] != null
          ? DateTime.parse(json['inspection_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'license_plate': licensePlate,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'vin': vin,
      'owner_id': ownerId,
      'registration_date': registrationDate.toIso8601String(),
      'inspection_date': inspectionDate?.toIso8601String(),
    };
  }

  VehicleModel copyWith({
    String? id,
    String? licensePlate,
    String? make,
    String? model,
    int? year,
    String? color,
    String? vin,
    String? ownerId,
    DateTime? registrationDate,
    DateTime? inspectionDate,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      licensePlate: licensePlate ?? this.licensePlate,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      vin: vin ?? this.vin,
      ownerId: ownerId ?? this.ownerId,
      registrationDate: registrationDate ?? this.registrationDate,
      inspectionDate: inspectionDate ?? this.inspectionDate,
    );
  }
}
