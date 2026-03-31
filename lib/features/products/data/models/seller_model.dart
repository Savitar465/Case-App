import 'package:drift/drift.dart';

import 'package:market_app/core/database/app_database.dart';
import 'package:market_app/features/products/domain/entities/seller.dart';

class SellerModel extends Seller {
  const SellerModel({
    required super.id,
    required super.userId,
    required super.storeName,
    super.storeSlug,
    super.description,
    super.logoUrl,
    super.bannerUrl,
    super.createdAt,
    super.updatedAt,
    super.syncedAt,
  });

  factory SellerModel.fromRemote(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic value) {
      if (value is DateTime) {
        return value;
      }
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return SellerModel(
      id: (map['id'] ?? map['seller_id']).toString(),
      userId: (map['user_id'] ?? map['userId']).toString(),
      storeName: (map['store_name'] ?? map['storeName'] ?? 'Store').toString(),
      storeSlug: map['store_slug']?.toString(),
      description: map['description']?.toString(),
      logoUrl: map['logo_url']?.toString(),
      bannerUrl: map['banner_url']?.toString(),
      createdAt: parseDate(map['created_at'] ?? map['createdAt']),
      updatedAt: parseDate(map['updated_at'] ?? map['updatedAt']),
      syncedAt: DateTime.now().toUtc(),
    );
  }

  factory SellerModel.fromTable(SellersTableData data) {
    return SellerModel(
      id: data.id,
      userId: data.userId,
      storeName: data.storeName,
      storeSlug: data.storeSlug,
      description: data.description,
      logoUrl: data.logoUrl,
      bannerUrl: data.bannerUrl,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      syncedAt: data.syncedAt,
    );
  }

  SellersTableCompanion toCompanion({DateTime? syncedAtOverride}) {
    return SellersTableCompanion(
      id: Value(id),
      userId: Value(userId),
      storeName: Value(storeName),
      storeSlug: Value(storeSlug),
      description: Value(description),
      logoUrl: Value(logoUrl),
      bannerUrl: Value(bannerUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: Value(syncedAtOverride ?? syncedAt),
    );
  }

  @override
  SellerModel copyWith({
    String? id,
    String? userId,
    String? storeName,
    String? storeSlug,
    String? description,
    String? logoUrl,
    String? bannerUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
  }) {
    return SellerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      storeSlug: storeSlug ?? this.storeSlug,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Seller toEntity() {
    return Seller(
      id: id,
      userId: userId,
      storeName: storeName,
      storeSlug: storeSlug,
      description: description,
      logoUrl: logoUrl,
      bannerUrl: bannerUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncedAt: syncedAt,
    );
  }
}
