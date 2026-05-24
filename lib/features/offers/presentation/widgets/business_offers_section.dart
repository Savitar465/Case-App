import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/discount_type.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offer_repository.dart';
import '../bloc/offer_list_cubit.dart';

/// Horizontal carousel of promotional offers embedded in a parent scroll view
/// (e.g. BusinessProfilePage), rendered as the red "Oferta Flash" cards.
///
/// Owns its own [OfferListCubit] scoped to [businessId] unless a [cubit] is
/// supplied, in which case the parent controls its lifecycle and refresh.
class BusinessOffersSection extends StatelessWidget {
  const BusinessOffersSection({
    super.key,
    required this.businessId,
    this.cubit,
  });

  final String businessId;

  /// Optional externally-owned cubit. When provided, the parent controls its
  /// lifecycle and can trigger [OfferListCubit.refresh] (e.g. pull-to-refresh).
  /// When null, this widget creates and owns its own cubit.
  final OfferListCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final externalCubit = cubit;
    if (externalCubit != null) {
      return BlocProvider<OfferListCubit>.value(
        value: externalCubit,
        child: const _SectionBody(),
      );
    }
    return BlocProvider<OfferListCubit>(
      create: (context) => OfferListCubit(
        repository: context.read<OfferRepository>(),
        businessId: businessId,
      )..initialize(),
      child: const _SectionBody(),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferListCubit, OfferListState>(
      builder: (context, state) {
        final offers = state.visibleOffers;
        if (state.isLoading && offers.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // No banner shown when there's nothing valid to promote.
        if (offers.isEmpty) return const SizedBox.shrink();
        return OffersCarousel(offers: offers);
      },
    );
  }
}

class OffersCarousel extends StatelessWidget {
  const OffersCarousel({super.key, required this.offers});

  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => OfferCard(offer: offers[index]),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer});

  static const Color _cardColor = Color(0xFFD32030);

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final image = offer.imageUrl;
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _FlashBadge(),
                  const SizedBox(height: 6),
                  Text(
                    offer.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _discountLabel(offer),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (image != null && image.isNotEmpty)
            SizedBox(
              width: 110,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }

  String _discountLabel(Offer offer) {
    final value = offer.discountValue;
    final isWhole = value.truncateToDouble() == value;
    final amount = value.toStringAsFixed(isWhole ? 0 : 2);
    switch (offer.discountType) {
      case DiscountType.percentage:
        return '$amount% de descuento';
      case DiscountType.fixedAmount:
        return 'Bs. $amount de descuento';
      case DiscountType.unknown:
        return offer.description;
    }
  }
}

class _FlashBadge extends StatelessWidget {
  const _FlashBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: Colors.amber, size: 14),
          SizedBox(width: 4),
          Text(
            'OFERTA FLASH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
