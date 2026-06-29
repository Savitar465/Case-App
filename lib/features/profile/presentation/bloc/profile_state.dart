part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, ready, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.overview,
    this.error,
  });

  final ProfileStatus status;
  final ProfileOverview? overview;
  final String? error;

  bool get isLoading => status == ProfileStatus.loading;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileOverview? overview,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, overview, error];
}
