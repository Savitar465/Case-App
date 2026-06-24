import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/discount_type.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offer_repository.dart';
import '../bloc/offer_list_cubit.dart';

/// Horizontal carousel of promotional offers embedded in a parent scroll view
/// (e.g. BusinessProfilePage), rendered as image cards with overlaid title.
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
      height: 150,
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

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final image = offer.imageUrl;
    return Container(
      width: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null && image.isNotEmpty)
            Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _OfferBackdrop(),
            )
          else
            const _OfferBackdrop(),
          // Dark gradient so the overlaid title stays readable.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
          if (_isNew(offer))
            const Positioned(top: 8, left: 8, child: _NuevoBadge()),
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.favorite_border, color: Colors.white, size: 20),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  offer.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 6),
                _EndsTodayPill(offer: offer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static bool _isNew(Offer offer) {
    final age = DateTime.now().difference(offer.createdAt);
    return age.inDays <= 7;
  }
}

class _OfferBackdrop extends StatelessWidget {
  const _OfferBackdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.purple, Color(0xFF6A2BD6)],
        ),
      ),
    );
  }
}

class _NuevoBadge extends StatelessWidget {
  const _NuevoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.badgeGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Nuevo',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Purple "Solo hoy" pill shown when the offer ends today, otherwise the
/// discount label.
class _EndsTodayPill extends StatelessWidget {
  const _EndsTodayPill({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final label = _endsToday(offer) ? 'Solo hoy' : _discountLabel(offer);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static bool _endsToday(Offer offer) {
    final now = DateTime.now();
    final end = offer.endDate;
    return end.year == now.year && end.month == now.month && end.day == now.day;
  }

  static String _discountLabel(Offer offer) {
    final value = offer.discountValue;
    final isWhole = value.truncateToDouble() == value;
    final amount = value.toStringAsFixed(isWhole ? 0 : 2);
    switch (offer.discountType) {
      case DiscountType.percentage:
        return '$amount% OFF';
      case DiscountType.fixedAmount:
        return '-Bs. $amount';
      case DiscountType.unknown:
        return 'Oferta';
    }
  }
}
