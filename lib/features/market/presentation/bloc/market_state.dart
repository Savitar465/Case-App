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
    this.maxDistanceKm,
    this.priceTier,
    this.userLatitude,
    this.userLongitude,
    this.locationLabel = 'Pando',
    this.isManualLocation = false,
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
  final double? maxDistanceKm;
  final String? priceTier;
  final double? userLatitude;
  final double? userLongitude;
  final String locationLabel;
  final bool isManualLocation;
  final bool isLoading;
  final String? error;

  bool get hasUserLocation => userLatitude != null && userLongitude != null;

  int get activeFiltersCount {
    var count = 0;
    if (selectedCategoryId != null) count++;
    if (openNowOnly) count++;
    if (offersOnly) count++;
    if (sortByDistance) count++;
    if (maxDistanceKm != null) count++;
    if (priceTier != null) count++;
    return count;
  }

  bool get hasActiveFilters => activeFiltersCount > 0;

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
      if (maxDistanceKm != null && hasUserLocation) {
        final dist = distanceTo(b);
        if (dist != null && dist > maxDistanceKm! * 1000) {
          return false;
        }
      }
      if (priceTier != null) {
        if (priceTier == 'premium' && !b.isPro) return false;
      }
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
    double? maxDistanceKm,
    bool clearMaxDistance = false,
    String? priceTier,
    bool clearPriceTier = false,
    double? userLatitude,
    double? userLongitude,
    String? locationLabel,
    bool? isManualLocation,
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
      maxDistanceKm: clearMaxDistance
          ? null
          : maxDistanceKm ?? this.maxDistanceKm,
      priceTier: clearPriceTier ? null : priceTier ?? this.priceTier,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      locationLabel: locationLabel ?? this.locationLabel,
      isManualLocation: isManualLocation ?? this.isManualLocation,
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
    maxDistanceKm,
    priceTier,
    userLatitude,
    userLongitude,
    locationLabel,
    isManualLocation,
    isLoading,
    error,
  ];
}
