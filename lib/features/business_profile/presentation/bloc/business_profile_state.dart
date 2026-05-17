part of 'business_profile_cubit.dart';

class BusinessProfileState extends Equatable {
  const BusinessProfileState({
    this.businesses = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Business> businesses;
  final bool isLoading;
  final String? error;

  BusinessProfileState copyWith({
    List<Business>? businesses,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BusinessProfileState(
      businesses: businesses ?? this.businesses,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [businesses, isLoading, error];
}
