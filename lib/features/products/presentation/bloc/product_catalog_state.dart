part of 'product_catalog_cubit.dart';

class ProductCatalogState extends Equatable {
  const ProductCatalogState({
    required this.products,
    required this.isLoading,
    required this.isSyncing,
    required this.hasPendingChanges,
    this.lastSyncedAt,
    this.errorMessage,
  });

  const ProductCatalogState.initial()
    : products = const [],
      isLoading = true,
      isSyncing = false,
      hasPendingChanges = false,
      lastSyncedAt = null,
      errorMessage = null;

  final List<Product> products;
  final bool isLoading;
  final bool isSyncing;
  final bool hasPendingChanges;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  int get pendingCount =>
      products.where((product) => product.hasPendingChanges).length;

  ProductCatalogState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isSyncing,
    bool? hasPendingChanges,
    DateTime? lastSyncedAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductCatalogState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoading,
    isSyncing,
    hasPendingChanges,
    lastSyncedAt,
    errorMessage,
  ];
}
