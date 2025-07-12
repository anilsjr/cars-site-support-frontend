import 'role.dart';
import 'permission.dart';

class User {
  final String id;
  final int? numericId;
  final String firstName;
  final String lastName;
  final String userId;
  final String? mobileNo;
  final String email;
  final bool isActive;
  final bool isLocked;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? plantCode;
  final String? plantName;
  final int? roleId;
  final Role? role;
  final List<Permission>? permissions;
  final int? version;
  final String? accessToken;

  const User({
    required this.id,
    this.numericId,
    required this.firstName,
    required this.lastName,
    required this.userId,
    this.mobileNo,
    required this.email,
    required this.isActive,
    required this.isLocked,
    required this.createdAt,
    this.updatedAt,
    this.plantCode,
    this.plantName,
    this.roleId,
    this.role,
    this.permissions,
    this.version,
    this.accessToken,
  });

  String get name => '$firstName $lastName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          numericId == other.numericId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          userId == other.userId &&
          mobileNo == other.mobileNo &&
          email == other.email &&
          isActive == other.isActive &&
          isLocked == other.isLocked;

  @override
  int get hashCode =>
      id.hashCode ^
      numericId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      userId.hashCode ^
      mobileNo.hashCode ^
      email.hashCode ^
      isActive.hashCode ^
      isLocked.hashCode;

  @override
  String toString() {
    return 'User{id: $id, numericId: $numericId, firstName: $firstName, lastName: $lastName, userId: $userId, mobileNo: $mobileNo, email: $email, isActive: $isActive, isLocked: $isLocked}';
  }
}
