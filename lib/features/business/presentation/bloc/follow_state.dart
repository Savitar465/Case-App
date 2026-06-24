part of 'follow_cubit.dart';

class FollowState extends Equatable {
  const FollowState({
    this.isFollowing = false,
    this.followersCount = 0,
    this.isToggling = false,
    this.error,
  });

  final bool isFollowing;
  final int followersCount;
  final bool isToggling;
  final String? error;

  FollowState copyWith({
    bool? isFollowing,
    int? followersCount,
    bool? isToggling,
    String? error,
    bool clearError = false,
  }) {
    return FollowState(
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      isToggling: isToggling ?? this.isToggling,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isFollowing, followersCount, isToggling, error];
}
