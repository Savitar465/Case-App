part of 'market_cubit.dart';

class MarketState extends Equatable {
  const MarketState({
    this.categories = const [],
    this.businesses = const [],
    this.offers = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.openNowOnly = false,
    this.offersOnly = false,
    this.sortByDistance = false,
    this.userLatitude,
    this.userLongitude,
    this.locationLabel = 'Pando',
    this.isLoading = false,
    this.error,
  });

  final List<MarketCategory> categories;
  final List<Business> businesses;
  final List<HomeOffer> offers;
  final String? selectedCategoryId;
  final String searchQuery;
  final bool openNowOnly;
  final bool offersOnly;
  final bool sortByDistance;
  final double? userLatitude;
  final double? userLongitude;
  final String locationLabel;
  final bool isLoading;
  final String? error;

  bool get hasUserLocation => userLatitude != null && userLongitude != null;

  bool get hasActiveFilters =>
      selectedCategoryId != null || openNowOnly || offersOnly || sortByDistance;

  Set<String> get businessIdsWithOffers => {
    for (final offer in offers) offer.businessId,
  };

  double? distanceTo(Business business) => hasUserLocation
      ? business.distanceMetersTo(userLatitude!, userLongitude!)
      : null;

  /// Businesses after applying the category chip and filter chips.
  List<Business> get visibleBusinesses {
    final now = DateTime.now();
    final withOffers = businessIdsWithOffers;
    final query = searchQuery.trim().toLowerCase();
    final result = businesses.where((b) {
      if (query.isNotEmpty &&
          !b.name.toLowerCase().contains(query) &&
          !(b.description?.toLowerCase().contains(query) ?? false) &&
          !b.address.toLowerCase().contains(query)) {
        return false;
      }
      if (selectedCategoryId != null && b.categoryId != selectedCategoryId) {
        return false;
      }
      if (openNowOnly && b.openingHours.currentRange(now) == null) {
        return false;
      }
      if (offersOnly && !withOffers.contains(b.id)) return false;
      return true;
    }).toList();
    if (sortByDistance && hasUserLocation) {
      double key(Business b) => distanceTo(b) ?? double.infinity;
      result.sort((a, b) => key(a).compareTo(key(b)));
    }
    return result;
  }

  List<Business> get featuredBusinesses =>
      visibleBusinesses.where((b) => b.isPro || b.isFeatured).toList();

  MarketState copyWith({
    List<MarketCategory>? categories,
    List<Business>? businesses,
    List<HomeOffer>? offers,
    String? selectedCategoryId,
    bool clearSelectedCategory = false,
    String? searchQuery,
    bool? openNowOnly,
    bool? offersOnly,
    bool? sortByDistance,
    double? userLatitude,
    double? userLongitude,
    String? locationLabel,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MarketState(
      categories: categories ?? this.categories,
      businesses: businesses ?? this.businesses,
      offers: offers ?? this.offers,
      selectedCategoryId: clearSelectedCategory
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      openNowOnly: openNowOnly ?? this.openNowOnly,
      offersOnly: offersOnly ?? this.offersOnly,
      sortByDistance: sortByDistance ?? this.sortByDistance,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      locationLabel: locationLabel ?? this.locationLabel,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    businesses,
    offers,
    selectedCategoryId,
    searchQuery,
    openNowOnly,
    offersOnly,
    sortByDistance,
    userLatitude,
    userLongitude,
    locationLabel,
    isLoading,
    error,
  ];
}
