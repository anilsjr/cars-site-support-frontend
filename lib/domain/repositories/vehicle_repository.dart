import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getAllVehicles();
  Future<Vehicle> getVehicleById(String id);
  Future<Vehicle> createVehicle(Vehicle vehicle);
  Future<Vehicle> updateVehicle(Vehicle vehicle);
  Future<void> deleteVehicle(String id);
  Future<List<Vehicle>> searchVehicles(String query);
}
