part of 'market_cubit.dart';

class MarketState extends Equatable {
  const MarketState({
    this.categories = const [],
    this.businesses = const [],
    this.isLoading = false,
    this.error,
  });

  final List<MarketCategory> categories;
  final List<Business> businesses;
  final bool isLoading;
  final String? error;

  MarketState copyWith({
    List<MarketCategory>? categories,
    List<Business>? businesses,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MarketState(
      categories: categories ?? this.categories,
      businesses: businesses ?? this.businesses,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [categories, businesses, isLoading, error];
}