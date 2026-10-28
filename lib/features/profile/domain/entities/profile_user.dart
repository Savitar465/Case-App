import 'package:equatable/equatable.dart';

/// The signed-in (or guest) user as rendered on the profile header.
class ProfileUser extends Equatable {
  const ProfileUser({
    required this.isGuest,
    this.id,
    this.displayName,
    this.email,
    this.location,
    this.username,
    this.avatarUrl,
  });

  const ProfileUser.guest()
    : isGuest = true,
      id = null,
      displayName = null,
      email = null,
      location = null,
      username = null,
      avatarUrl = null;

  final bool isGuest;
  final String? id;
  final String? displayName;
  final String? email;
  final String? location;

  /// Handle without the `@`.
  final String? username;

  /// Public URL of the profile photo.
  final String? avatarUrl;

  /// Best label available for the user.
  String get name {
    final trimmed = displayName?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    if (isGuest) return 'Invitado';
    final localPart = email?.split('@').first;
    return (localPart != null && localPart.isNotEmpty) ? localPart : 'Usuario';
  }

  /// Single letter shown inside the avatar.
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  @override
  List<Object?> get props => [
    isGuest,
    id,
    displayName,
    email,
    location,
    username,
    avatarUrl,
  ];
}
