class Vehicle {
  final String id;
  final String licensePlate;
  final String make;
  final String model;
  final int year;
  final String color;
  final String vin;
  final String ownerId;
  final DateTime registrationDate;
  final DateTime? inspectionDate;

  const Vehicle({
    required this.id,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.vin,
    required this.ownerId,
    required this.registrationDate,
    this.inspectionDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          licensePlate == other.licensePlate &&
          vin == other.vin;

  @override
  int get hashCode => id.hashCode ^ licensePlate.hashCode ^ vin.hashCode;

  @override
  String toString() {
    return 'Vehicle{id: $id, licensePlate: $licensePlate, make: $make, model: $model, year: $year}';
  }
}
