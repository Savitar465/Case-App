part of 'offers_feed_cubit.dart';

/// "Vencimiento" filter options.
enum ExpiryFilter {
  any('Cualquier fecha', null),
  today('Terminan hoy', Duration(hours: 24)),
  threeDays('Próximos 3 días', Duration(days: 3)),
  week('Esta semana', Duration(days: 7));

  const ExpiryFilter(this.label, this.window);

  final String label;

  /// Offers must end within this window; `null` = no limit.
  final Duration? window;
}

/// The three carousels of the tab, also used by "Ver todas".
enum OffersSection { endingSoon, followed, all }

class OffersFeedState extends Equatable {
  const OffersFeedState({
    this.offers = const [],
    this.followedBusinessIds = const {},
    this.isLoading = false,
    this.error,
    this.query = '',
    this.expiry = ExpiryFilter.any,
    this.minDiscount,
    this.businessIds = const {},
  });

  /// Offers ending within this window land in "Terminan pronto".
  static const endingSoonWindow = Duration(hours: 24);

  static const discountOptions = [10, 20, 30, 50];

  final List<OfferDetail> offers;
  final Set<String> followedBusinessIds;
  final bool isLoading;
  final String? error;
  final String query;
  final ExpiryFilter expiry;

  /// Minimum discount percentage, `null` = any.
  final int? minDiscount;

  /// Selected businesses for the "Negocio" filter, empty = all.
  final Set<String> businessIds;

  bool get hasFilters =>
      expiry != ExpiryFilter.any ||
      minDiscount != null ||
      businessIds.isNotEmpty;

  int get activeFilterCount =>
      (expiry != ExpiryFilter.any ? 1 : 0) +
      (minDiscount != null ? 1 : 0) +
      (businessIds.isNotEmpty ? 1 : 0);

  /// Businesses that currently have offers, for the "Negocio" filter.
  List<({String id, String name})> get businesses {
    final byId = <String, String>{};
    for (final offer in offers) {
      byId[offer.businessId] = offer.businessName;
    }
    return [
      for (final entry in byId.entries) (id: entry.key, name: entry.value),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  /// Offers available at [now] that pass the search and filters, soonest
  /// ending first.
  List<OfferDetail> visibleOffers(DateTime now) {
    final needle = query.trim().toLowerCase();
    final window = expiry.window;
    final min = minDiscount;
    return offers.where((offer) {
      if (!offer.isAvailableAt(now)) return false;
      if (window != null && offer.endsAt(now).difference(now) > window) {
        return false;
      }
      if (min != null && (offer.discountPercent ?? 0) < min) return false;
      if (businessIds.isNotEmpty && !businessIds.contains(offer.businessId)) {
        return false;
      }
      if (needle.isNotEmpty &&
          !offer.title.toLowerCase().contains(needle) &&
          !offer.businessName.toLowerCase().contains(needle) &&
          !(offer.categoryName?.toLowerCase().contains(needle) ?? false)) {
        return false;
      }
      return true;
    }).toList()..sort((a, b) => a.endsAt(now).compareTo(b.endsAt(now)));
  }

  List<OfferDetail> section(OffersSection section, DateTime now) {
    final visible = visibleOffers(now);
    return switch (section) {
      OffersSection.endingSoon =>
        visible
            .where((o) => o.endsAt(now).difference(now) <= endingSoonWindow)
            .toList(),
      OffersSection.followed =>
        visible
            .where((o) => followedBusinessIds.contains(o.businessId))
            .toList(),
      OffersSection.all => visible,
    };
  }

  OffersFeedState copyWith({
    List<OfferDetail>? offers,
    Set<String>? followedBusinessIds,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? query,
    ExpiryFilter? expiry,
    int? minDiscount,
    bool clearMinDiscount = false,
    Set<String>? businessIds,
  }) {
    return OffersFeedState(
      offers: offers ?? this.offers,
      followedBusinessIds: followedBusinessIds ?? this.followedBusinessIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      query: query ?? this.query,
      expiry: expiry ?? this.expiry,
      minDiscount: clearMinDiscount ? null : minDiscount ?? this.minDiscount,
      businessIds: businessIds ?? this.businessIds,
    );
  }

  @override
  List<Object?> get props => [
    offers,
    followedBusinessIds,
    isLoading,
    error,
    query,
    expiry,
    minDiscount,
    businessIds,
  ];
}
