import '../../domain/entities/user.dart';
import 'role_model.dart';
import 'permission_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    super.numericId,
    required super.firstName,
    required super.lastName,
    required super.userId,
    super.mobileNo,
    required super.email,
    required super.isActive,
    required super.isLocked,
    required super.createdAt,
    super.updatedAt,
    super.plantCode,
    super.plantName,
    super.roleId,
    super.role,
    super.permissions,
    super.version,
    super.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      numericId: json['id']?.toInt(),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString(),
      email: json['email']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      isLocked: json['is_locked'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      plantCode: json['plant_code']?.toString(),
      plantName: json['plant_name']?.toString(),
      roleId: json['role_id']?.toInt(),
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null,
      permissions: json['permissions'] != null
          ? (json['permissions'] as List)
                .map((permission) => PermissionModel.fromJson(permission))
                .toList()
          : null,
      version: json['__v']?.toInt(),
      accessToken: json['accessToken']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': numericId,
      'first_name': firstName,
      'last_name': lastName,
      'user_id': userId,
      'mobile_no': mobileNo,
      'email': email,
      'is_active': isActive,
      'is_locked': isLocked,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'plant_code': plantCode,
      'plant_name': plantName,
      'role_id': roleId,
      'role': role != null && role is RoleModel
          ? (role as RoleModel).toJson()
          : null,
      'permissions': permissions
          ?.map((permission) {
            if (permission is PermissionModel) {
              return permission.toJson();
            }
            return null;
          })
          .where((element) => element != null)
          .toList(),
      '__v': version,
      'accessToken': accessToken,
    };
  }

  UserModel copyWith({
    String? id,
    int? numericId,
    String? firstName,
    String? lastName,
    String? userId,
    String? mobileNo,
    String? email,
    bool? isActive,
    bool? isLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? plantCode,
    String? plantName,
    int? roleId,
    RoleModel? role,
    List<PermissionModel>? permissions,
    int? version,
    String? accessToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      numericId: numericId ?? this.numericId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userId: userId ?? this.userId,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plantCode: plantCode ?? this.plantCode,
      plantName: plantName ?? this.plantName,
      roleId: roleId ?? this.roleId,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      version: version ?? this.version,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
