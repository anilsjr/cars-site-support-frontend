import '../../domain/entities/permission.dart';

class PermissionModel extends Permission {
  const PermissionModel({
    required super.roleId,
    required super.permissionsId,
    required super.permissionSubcategoryName,
    required super.permissionSubcategoryKey,
    required super.permissionCategoryName,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      roleId: json['role_id']?.toInt() ?? 0,
      permissionsId: json['permissions_id']?.toInt() ?? 0,
      permissionSubcategoryName:
          json['permission_subcategory_name']?.toString() ?? '',
      permissionSubcategoryKey:
          json['permission_subcategory_key']?.toString() ?? '',
      permissionCategoryName:
          json['permission_category_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'permissions_id': permissionsId,
      'permission_subcategory_name': permissionSubcategoryName,
      'permission_subcategory_key': permissionSubcategoryKey,
      'permission_category_name': permissionCategoryName,
    };
  }

  // PermissionModel copyWith({
  //   int? roleId,
  //   int? permissionsId,
  //   String? permissionSubcategoryName,
  //   String? permissionSubcategoryKey,
  //   String? permissionCategoryName,
  // }) {
  //   return PermissionModel(
  //     roleId: roleId ?? this.roleId,
  //     permissionsId: permissionsId ?? this.permissionsId,
  //     permissionSubcategoryName:
  //         permissionSubcategoryName ?? this.permissionSubcategoryName,
  //     permissionSubcategoryKey:
  //         permissionSubcategoryKey ?? this.permissionSubcategoryKey,
  //     permissionCategoryName:
  //         permissionCategoryName ?? this.permissionCategoryName,
  //   );
  // }
}
