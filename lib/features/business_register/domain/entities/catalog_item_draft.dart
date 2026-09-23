import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show TimeOfDay;

/// Whether a catalog entry is a service or a product.
enum CatalogItemKind { service, product }

extension CatalogItemKindX on CatalogItemKind {
  String get singular =>
      this == CatalogItemKind.service ? 'servicio' : 'producto';
  String get title => this == CatalogItemKind.service ? 'Servicio' : 'Producto';

  String get nameHint => this == CatalogItemKind.service
      ? 'Ej: Limpieza dental'
      : 'Ej: Hamburguesa clásica';
}

/// Offer attached to a catalog item: none, or a short-lived flash discount.
enum OfferType { none, flash }

/// Flash-offer configuration for a catalog item.
class FlashOffer extends Equatable {
  const FlashOffer({
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    this.repeatWeekdays = const {},
  });

  final double? price;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  /// Weekdays the offer repeats on ([DateTime.monday]..[DateTime.sunday]).
  final Set<int> repeatWeekdays;

  @override
  List<Object?> get props => [
    price,
    startDate,
    endDate,
    startTime,
    endTime,
    repeatWeekdays,
  ];
}

/// A service or product the owner adds during registration.
class CatalogItemDraft extends Equatable {
  const CatalogItemDraft({
    required this.id,
    required this.kind,
    required this.name,
    this.price,
    this.offerType = OfferType.none,
    this.flashOffer,
    this.quantity,
    this.description,
    this.photoPath,
  });

  final String id;
  final CatalogItemKind kind;
  final String name;
  final double? price;

  /// Offer configuration.
  final OfferType offerType;
  final FlashOffer? flashOffer;

  /// Available quantity; null means unlimited.
  final int? quantity;

  final String? description;

  /// Local path of the picked photo, if any.
  final String? photoPath;

  @override
  List<Object?> get props => [
    id,
    kind,
    name,
    price,
    offerType,
    flashOffer,
    quantity,
    description,
    photoPath,
  ];
}
