part of 'follow_list_cubit.dart';

class FollowListState extends Equatable {
  const FollowListState({
    this.follows = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Follow> follows;
  final bool isLoading;
  final String? error;

  bool isFollowing(String businessId) =>
      follows.any((f) => f.businessId == businessId);

  FollowListState copyWith({
    List<Follow>? follows,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FollowListState(
      follows: follows ?? this.follows,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [follows, isLoading, error];
}
