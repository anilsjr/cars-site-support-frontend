class Role {
  final int id;
  final String roleName;

  const Role({required this.id, required this.roleName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Role &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          roleName == other.roleName;

  @override
  int get hashCode => id.hashCode ^ roleName.hashCode;

  @override
  String toString() {
    return 'Role{id: $id, roleName: $roleName}';
  }
}
