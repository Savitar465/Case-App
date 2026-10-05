import 'package:equatable/equatable.dart';

import 'favorite_kind.dart';

/// Something the user saved, flattened for the favorites lists.
class FavoriteEntry extends Equatable {
  const FavoriteEntry({
    required this.kind,
    required this.targetId,
    required this.businessId,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.price,
    this.currency,
    this.savedAt,
  });

  final FavoriteKind kind;

  /// Id of the business / item / offer that was saved.
  final String targetId;

  /// Business that owns the target (equals [targetId] for businesses).
  final String businessId;
  final String title;

  /// Business name for items/offers, address for businesses.
  final String? subtitle;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final DateTime? savedAt;

  @override
  List<Object?> get props => [
    kind,
    targetId,
    businessId,
    title,
    subtitle,
    imageUrl,
    price,
    currency,
    savedAt,
  ];
}
