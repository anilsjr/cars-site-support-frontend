class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ phoneNumber.hashCode;

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name, phoneNumber: $phoneNumber}';
  }
}
