part of 'offer_list_cubit.dart';

class OfferListState extends Equatable {
  const OfferListState({
    this.offers = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Offer> offers;
  final bool isLoading;
  final String? error;

  /// Active offers whose validity window (RN-03) covers the current moment.
  List<Offer> get visibleOffers {
    final now = DateTime.now().toUtc();
    return offers
        .where(
          (o) =>
              o.isActive &&
              !o.startDate.isAfter(now) &&
              !o.endDate.isBefore(now),
        )
        .toList();
  }

  OfferListState copyWith({
    List<Offer>? offers,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return OfferListState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [offers, isLoading, error];
}
