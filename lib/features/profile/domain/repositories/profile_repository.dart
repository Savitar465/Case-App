import '../entities/profile_overview.dart';

abstract class ProfileRepository {
  /// Loads the profile header plus the followed and owned businesses for the
  /// signed-in user. Returns a guest overview when there is no session.
  Future<ProfileOverview> loadOverview();

  /// Removes the follow row linking the current user to [businessId].
  Future<void> unfollow(String businessId);
}
