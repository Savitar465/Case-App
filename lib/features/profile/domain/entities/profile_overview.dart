import 'package:equatable/equatable.dart';

import 'profile_business.dart';
import 'profile_user.dart';

/// Everything the profile screen needs in a single payload: the user header,
/// the businesses they follow and the businesses they own.
class ProfileOverview extends Equatable {
  const ProfileOverview({
    required this.user,
    this.followed = const [],
    this.owned = const [],
  });

  final ProfileUser user;
  final List<ProfileBusiness> followed;
  final List<ProfileBusiness> owned;

  /// True when the user manages at least one business (switches the layout
  /// between the "register a business" promo and the "my businesses" section).
  bool get hasBusinesses => owned.isNotEmpty;

  ProfileOverview copyWith({
    ProfileUser? user,
    List<ProfileBusiness>? followed,
    List<ProfileBusiness>? owned,
  }) {
    return ProfileOverview(
      user: user ?? this.user,
      followed: followed ?? this.followed,
      owned: owned ?? this.owned,
    );
  }

  @override
  List<Object?> get props => [user, followed, owned];
}
