import 'package:equatable/equatable.dart';

/// Authorization role assigned to an authenticated user.
enum UserRole { admin, seller, customer, unknown }

/// Parses the role string returned by Supabase (or stored locally).
///
/// Returns [UserRole.customer] for null/empty input (the safe default for a
/// freshly-signed-in user) and [UserRole.unknown] for values the app does not
/// recognize so callers can decide how to handle them.
UserRole userRoleFromString(String? value) {
  if (value == null || value.isEmpty) {
    return UserRole.customer;
  }
  switch (value.toLowerCase()) {
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

/// Domain representation of an authenticated user.
///
/// Persistence (Drift) and wire (Supabase) shapes live in `data/models/`.
class AuthUser extends Equatable {
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

  @override
  List<Object?> get props => [id, email, displayName, role, sellerId];
}
