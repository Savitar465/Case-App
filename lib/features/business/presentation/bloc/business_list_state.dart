part of 'business_list_cubit.dart';

class BusinessListState extends Equatable {
  const BusinessListState({
    this.businesses = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Business> businesses;
  final bool isLoading;
  final String? error;

  BusinessListState copyWith({
    List<Business>? businesses,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BusinessListState(
      businesses: businesses ?? this.businesses,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [businesses, isLoading, error];
}
