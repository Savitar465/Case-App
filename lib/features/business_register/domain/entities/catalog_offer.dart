import 'package:equatable/equatable.dart';

import 'catalog_item_draft.dart';

enum CatalogOfferStatus { active, scheduled, expired, paused }

/// A stored flash offer on one of the business's items.
class CatalogOffer extends Equatable {
  const CatalogOffer({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.normalPrice,
    required this.flashPrice,
    required this.schedule,
    required this.isActive,
    this.imageUrl,
  });

  final String id;

  /// Null for legacy offers not linked to an item (shown but not editable).
  final String? itemId;
  final String itemName;
  final double normalPrice;
  final double flashPrice;

  /// Validity window and daily hours; [FlashOffer.price] equals [flashPrice].
  final FlashOffer schedule;
  final bool isActive;
  final String? imageUrl;

  DateTime get startsAt => _at(
    schedule.startDate,
    schedule.startTime.hour,
    schedule.startTime.minute,
  );

  DateTime get endsAt =>
      _at(schedule.endDate, schedule.endTime.hour, schedule.endTime.minute);

  CatalogOfferStatus statusAt(DateTime now) {
    if (!isActive) return CatalogOfferStatus.paused;
    if (endsAt.isBefore(now)) return CatalogOfferStatus.expired;
    if (startsAt.isAfter(now)) return CatalogOfferStatus.scheduled;
    return CatalogOfferStatus.active;
  }

  static DateTime _at(DateTime day, int hour, int minute) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  @override
  List<Object?> get props => [
    id,
    itemId,
    itemName,
    normalPrice,
    flashPrice,
    schedule,
    isActive,
    imageUrl,
  ];
}
