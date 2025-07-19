import '../../domain/entities/role.dart';

class RoleModel extends Role {
  const RoleModel({required super.id, required super.roleName});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toInt() ?? 0,
      roleName: json['role_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'role_name': roleName};
  }

  // RoleModel copyWith({int? id, String? roleName}) {
  //   return RoleModel(id: id ?? this.id, roleName: roleName ?? this.roleName);
  // }
}
