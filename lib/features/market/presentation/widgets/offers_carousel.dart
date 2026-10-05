import 'package:flutter/material.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/market/domain/entities/home_offer.dart';
import 'package:market_app/features/market/presentation/widgets/business_cards.dart';

import '../../../../core/theme/app_palette.dart';

/// "Ofertas cerca de ti" banner carousel with page dots.
class OffersCarousel extends StatefulWidget {
  const OffersCarousel({super.key, required this.offers});

  final List<HomeOffer> offers;

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  final _controller = PageController(viewportFraction: 0.66);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offers = widget.offers;
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: offers.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 16 : 6, right: 6),
              child: _OfferBanner(offer: offers[index]),
            ),
          ),
        ),
        if (offers.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < offers.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? AppColors.purple
                        : context.palette.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner({required this.offer});

  final HomeOffer offer;

  /// "2x1"-style titles become the headline; otherwise the discount value.
  String get _headline {
    final promo = RegExp(r'^\d+\s*x\s*\d+').firstMatch(offer.title);
    if (promo != null) return promo.group(0)!.replaceAll(' ', '');
    final value = offer.discountValue % 1 == 0
        ? offer.discountValue.toStringAsFixed(0)
        : offer.discountValue.toStringAsFixed(1);
    return switch (offer.discountType) {
      'percentage' => '-$value%',
      'fixed_amount' => 'Bs $value',
      _ => 'OFERTA',
    };
  }

  String get _subtitle {
    final promo = RegExp(r'^\d+\s*x\s*\d+\s*').firstMatch(offer.title);
    return promo == null ? offer.title : offer.title.substring(promo.end);
  }

  bool get _endsToday {
    final now = DateTime.now();
    final end = offer.endDate;
    return end.year == now.year && end.month == now.month && end.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.offerRed,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openBusinessProfile(context, offer.businessId),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (offer.imageUrl != null)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 150,
                child: Image.network(
                  offer.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.offerRed,
                    AppColors.offerRed,
                    Color(0x00E53935),
                  ],
                  stops: [0, 0.45, 0.85],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Pill(
                    label: offer.isFlash ? 'OFERTA FLASH' : 'OFERTA',
                    icon: Icons.local_fire_department,
                    background: const Color(0xFFFFD54F),
                    foreground: Colors.black87,
                  ),
                  const Spacer(),
                  Text(
                    _headline,
                    style: const TextStyle(
                      color: Color(0xFFFFE082),
                      fontSize: 30,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    _subtitle.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          offer.businessName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _Pill(
                    label: _endsToday
                        ? 'SOLO HOY'
                        : 'HASTA ${offer.endDate.day}/${offer.endDate.month}',
                    background: Colors.black87,
                    foreground: const Color(0xFFFFD54F),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: AppColors.offerRed),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
