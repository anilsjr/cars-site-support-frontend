class Permission {
  final int roleId;
  final int permissionsId;
  final String permissionSubcategoryName;
  final String permissionSubcategoryKey;
  final String permissionCategoryName;

  const Permission({
    required this.roleId,
    required this.permissionsId,
    required this.permissionSubcategoryName,
    required this.permissionSubcategoryKey,
    required this.permissionCategoryName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Permission &&
          runtimeType == other.runtimeType &&
          roleId == other.roleId &&
          permissionsId == other.permissionsId &&
          permissionSubcategoryName == other.permissionSubcategoryName &&
          permissionSubcategoryKey == other.permissionSubcategoryKey &&
          permissionCategoryName == other.permissionCategoryName;

  @override
  int get hashCode =>
      roleId.hashCode ^
      permissionsId.hashCode ^
      permissionSubcategoryName.hashCode ^
      permissionSubcategoryKey.hashCode ^
      permissionCategoryName.hashCode;

  @override
  String toString() {
    return 'Permission{roleId: $roleId, permissionsId: $permissionsId, permissionSubcategoryName: $permissionSubcategoryName, permissionSubcategoryKey: $permissionSubcategoryKey, permissionCategoryName: $permissionCategoryName}';
  }
}
