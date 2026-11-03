part of 'catalog_cubit.dart';

class CatalogState extends Equatable {
  const CatalogState({
    required this.businessId,
    this.items = const [],
    this.offers = const [],
    this.isLoading = false,
    this.hasLoaded = false,
    this.busyIds = const {},
    this.error,
    this.message,
  });

  final String businessId;
  final List<CatalogItem> items;
  final List<CatalogOffer> offers;
  final bool isLoading;
  final bool hasLoaded;

  /// Ids of items/offers with a write in flight (their rows show a spinner).
  final Set<String> busyIds;

  /// Last failure, shown as a snackbar.
  final String? error;

  /// Last success notice, shown as a snackbar.
  final String? message;

  List<CatalogItem> itemsOf(CatalogItemKind kind) =>
      items.where((item) => item.kind == kind).toList();

  CatalogState copyWith({
    List<CatalogItem>? items,
    List<CatalogOffer>? offers,
    bool? isLoading,
    bool? hasLoaded,
    Set<String>? busyIds,
    String? error,
    bool clearError = false,
    String? message,
    bool clearMessage = false,
  }) {
    return CatalogState(
      businessId: businessId,
      items: items ?? this.items,
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      busyIds: busyIds ?? this.busyIds,
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    businessId,
    items,
    offers,
    isLoading,
    hasLoaded,
    busyIds,
    error,
    message,
  ];
}
