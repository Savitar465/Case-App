import 'package:market_app/features/auth/domain/entities/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.metadata,
    super.role,
    super.sellerId,
  });

  factory AuthUserModel.fromSupabase(supabase.User user) {
    final metadata = user.userMetadata;
    final metadataMap = metadata is Map<String, dynamic>
        ? metadata
        : <String, dynamic>{};
    final Map<String, dynamic> appMetadata = user.appMetadata;
    final displayName =
        metadataMap['full_name'] as String? ?? metadataMap['name'] as String?;

    final dynamic rawRole =
        metadataMap['role'] ??
        metadataMap['user_role'] ??
        appMetadata['role'] ??
        appMetadata['user_role'];
    final role = userRoleFromString(
      rawRole is String ? rawRole : rawRole?.toString(),
    );

    final dynamic rawSellerId =
        metadataMap['seller_id'] ??
        metadataMap['sellerId'] ??
        appMetadata['seller_id'] ??
        appMetadata['sellerId'];
    final sellerId = rawSellerId is String && rawSellerId.isNotEmpty
        ? rawSellerId
        : null;
    final metadataToPersist = metadataMap.isEmpty
        ? null
        : {
            ...metadataMap,
            if (role != UserRole.customer &&
                metadataMap['role'] == null &&
                metadataMap['user_role'] == null)
              'role': role.label,
            if (sellerId != null &&
                metadataMap['seller_id'] == null &&
                metadataMap['sellerId'] == null)
              'seller_id': sellerId,
          };
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: displayName,
      metadata: metadataToPersist,
      role: role,
      sellerId: sellerId,
    );
  }

  AuthUserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    Map<String, dynamic>? metadata,
    UserRole? role,
    String? sellerId,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      metadata: metadata ?? this.metadata,
      role: role ?? this.role,
      sellerId: sellerId ?? this.sellerId,
    );
  }
}
