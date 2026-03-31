import 'package:equatable/equatable.dart';

enum ProductSyncStatus { synced, pendingUpsert, pendingDelete }

extension ProductSyncStatusX on ProductSyncStatus {
  bool get isPending => this != ProductSyncStatus.synced;

  String get label => switch (this) {
    ProductSyncStatus.synced => 'synced',
    ProductSyncStatus.pendingUpsert => 'pending_upsert',
    ProductSyncStatus.pendingDelete => 'pending_delete',
  };
}

ProductSyncStatus productSyncStatusFromLabel(String? value) {
  if (value == null || value.isEmpty) {
    return ProductSyncStatus.synced;
  }
  final normalized = value.toLowerCase();
  switch (normalized) {
    case 'pending_upsert':
    case 'upsert':
      return ProductSyncStatus.pendingUpsert;
    case 'pending_delete':
    case 'delete':
      return ProductSyncStatus.pendingDelete;
    case 'synced':
      return ProductSyncStatus.synced;
    default:
      return ProductSyncStatus.synced;
  }
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.price,
    this.description,
    this.category,
    this.unit,
    this.quantity,
    this.isTrending = false,
    this.inStock = true,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
    this.metadata,
    this.syncStatus = ProductSyncStatus.synced,
  });

  final String id;
  final String sellerId;
  final String name;
  final double price;
  final String? description;
  final String? category;
  final String? unit;
  final int? quantity;
  final bool isTrending;
  final bool inStock;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  final Map<String, dynamic>? metadata;
  final ProductSyncStatus syncStatus;

  bool get hasPendingChanges => syncStatus.isPending;

  Product copyWith({
    String? id,
    String? sellerId,
    String? name,
    double? price,
    String? description,
    String? category,
    String? unit,
    int? quantity,
    bool? isTrending,
    bool? inStock,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    Map<String, dynamic>? metadata,
    ProductSyncStatus? syncStatus,
  }) {
    return Product(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      isTrending: isTrending ?? this.isTrending,
      inStock: inStock ?? this.inStock,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      metadata: metadata ?? this.metadata,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sellerId,
    name,
    price,
    description,
    category,
    unit,
    quantity,
    isTrending,
    inStock,
    rating,
    createdAt,
    updatedAt,
    syncedAt,
    metadata,
    syncStatus,
  ];
}
