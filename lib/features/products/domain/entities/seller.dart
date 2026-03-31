import 'package:equatable/equatable.dart';

class Seller extends Equatable {
  const Seller({
    required this.id,
    required this.userId,
    required this.storeName,
    this.storeSlug,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  final String id;
  final String userId;
  final String storeName;
  final String? storeSlug;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;

  Seller copyWith({
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
    return Seller(
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

  @override
  List<Object?> get props => [
    id,
    userId,
    storeName,
    storeSlug,
    description,
    logoUrl,
    bannerUrl,
    createdAt,
    updatedAt,
    syncedAt,
  ];
}
