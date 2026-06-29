import 'package:equatable/equatable.dart';

/// Lightweight business projection used across the profile screens (followed
/// businesses and the businesses owned by the current user).
class ProfileBusiness extends Equatable {
  const ProfileBusiness({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.status = 'pending',
    this.isPro = false,
    this.followersCount = 0,
    this.viewsCount = 0,
  });

  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final String status;
  final bool isPro;
  final int followersCount;
  final int viewsCount;

  /// Whether the business is currently published / open for business.
  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    imageUrl,
    status,
    isPro,
    followersCount,
    viewsCount,
  ];
}
