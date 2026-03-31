enum UserRole { admin, seller, customer, unknown }

UserRole userRoleFromString(String? value) {
  if (value == null || value.isEmpty) {
    return UserRole.customer;
  }
  final normalized = value.toLowerCase();
  switch (normalized) {
    case 'admin':
    case 'administrator':
      return UserRole.admin;
    case 'seller':
    case 'merchant':
    case 'vendor':
      return UserRole.seller;
    case 'buyer':
    case 'customer':
    case 'user':
      return UserRole.customer;
    default:
      return UserRole.unknown;
  }
}

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.admin => 'admin',
    UserRole.seller => 'seller',
    UserRole.customer => 'user',
    UserRole.unknown => 'unknown',
  };

  bool get canManageCatalog =>
      this == UserRole.admin || this == UserRole.seller;
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.metadata,
    this.role = UserRole.customer,
    this.sellerId,
  });

  final String id;
  final String email;
  final String? displayName;
  final Map<String, dynamic>? metadata;
  final UserRole role;
  final String? sellerId;
}
