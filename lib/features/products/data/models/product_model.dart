import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:market_app/core/database/app_database.dart';
import 'package:market_app/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.sellerId,
    required super.name,
    required super.price,
    super.description,
    super.category,
    super.unit,
    super.quantity,
    super.isTrending = false,
    super.inStock = true,
    super.rating,
    super.createdAt,
    super.updatedAt,
    super.syncedAt,
    super.metadata,
    super.syncStatus = ProductSyncStatus.synced,
    this.isDirty = false,
    this.pendingOperation,
  });

  final bool isDirty;
  final String? pendingOperation;

  bool get isMarkedForDeletion =>
      productSyncStatusFromLabel(pendingOperation) ==
      ProductSyncStatus.pendingDelete;

  factory ProductModel.fromEntity(Product product, {bool? dirtyOverride}) {
    final bool dirty = dirtyOverride ?? product.syncStatus.isPending;
    final String? pending = product.syncStatus.isPending
        ? product.syncStatus.label
        : null;
    return ProductModel(
      id: product.id,
      sellerId: product.sellerId,
      name: product.name,
      price: product.price,
      description: product.description,
      category: product.category,
      unit: product.unit,
      quantity: product.quantity,
      isTrending: product.isTrending,
      inStock: product.inStock,
      rating: product.rating,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      syncedAt: product.syncedAt,
      metadata: product.metadata,
      syncStatus: product.syncStatus,
      isDirty: dirty,
      pendingOperation: pending,
    );
  }

  static Map<String, dynamic>? _decodeMetadata(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {
        // Ignore malformed payloads; treat as absent metadata.
      }
    }
    return null;
  }

  factory ProductModel.fromRemote(Map<String, dynamic> map) {
    double parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        return double.tryParse(value) ?? 0;
      }
      return 0;
    }

    int? parseInt(dynamic value) {
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        return int.tryParse(value);
      }
      return null;
    }

    bool parseBool(dynamic value, {bool fallback = false}) {
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' || normalized == '0') {
          return false;
        }
      }
      return fallback;
    }

    DateTime? parseDate(dynamic value) {
      if (value is DateTime) {
        return value;
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      if (value is int) {
        // Assume milliseconds since epoch
        return DateTime.fromMillisecondsSinceEpoch(
          value,
          isUtc: true,
        ).toLocal();
      }
      return null;
    }

    final metadata = _decodeMetadata(
      map['metadata'] ?? map['metadata_json'] ?? map['metadataJson'],
    );
    final createdAt = parseDate(map['created_at'] ?? map['createdAt']);
    final updatedAt = parseDate(map['updated_at'] ?? map['updatedAt']);

    return ProductModel(
      id: (map['id'] ?? map['product_id']).toString(),
      name: (map['name'] ?? 'Untitled product').toString(),
      description: map['description']?.toString(),
      price: parseDouble(map['price']),
      quantity: parseInt(map['quantity']),
      updatedAt: updatedAt, sellerId: '',
    );
  }

  factory ProductModel.fromTable(ProductsTableData data) {
    return ProductModel(
      id: data.id,
      sellerId: data.sellerId,
      name: data.name,
      price: data.price,
      description: data.description,
      category: data.category,
      unit: data.unit,
      quantity: data.quantity,
      isTrending: data.isTrending,
      inStock: data.inStock,
      rating: data.rating,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      syncedAt: data.syncedAt,
      metadata: _decodeMetadata(data.metadataJson),
      syncStatus: data.pendingOperation != null
          ? productSyncStatusFromLabel(data.pendingOperation)
          : ProductSyncStatus.synced,
      isDirty: data.isDirty,
      pendingOperation: data.pendingOperation,
    );
  }

  ProductsTableCompanion toCompanion({
    bool? dirtyOverride,
    String? pendingOperationOverride,
    DateTime? syncedAtOverride,
    DateTime? updatedAtOverride,
  }) {
    final metadataJsonValue = metadata != null ? jsonEncode(metadata) : null;
    return ProductsTableCompanion(
      id: Value(id),
      sellerId: Value(sellerId),
      name: Value(name),
      description: Value(description),
      category: Value(category),
      unit: Value(unit),
      price: Value(price),
      quantity: Value(quantity),
      isTrending: Value(isTrending),
      inStock: Value(inStock),
      rating: Value(rating),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAtOverride ?? updatedAt),
      syncedAt: Value(syncedAtOverride ?? syncedAt),
      metadataJson: Value(metadataJsonValue),
      isDirty: dirtyOverride != null ? Value(dirtyOverride) : Value(isDirty),
      pendingOperation: pendingOperationOverride != null
          ? Value(pendingOperationOverride)
          : Value(pendingOperation),
    );
  }

  Map<String, dynamic> toRemoteMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  @override
  ProductModel copyWith({
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
    bool? isDirty,
    String? pendingOperation,
  }) {
    return ProductModel(
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
      isDirty: isDirty ?? this.isDirty,
      pendingOperation: pendingOperation ?? this.pendingOperation,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      sellerId: sellerId,
      name: name,
      price: price,
      description: description,
      category: category,
      unit: unit,
      quantity: quantity,
      isTrending: isTrending,
      inStock: inStock,
      rating: rating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncedAt: syncedAt,
      metadata: metadata,
      syncStatus: syncStatus,
    );
  }
}
