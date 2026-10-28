import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../favorites/domain/entities/favorite_kind.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/discount_type.dart';
import '../../domain/entities/offer_detail.dart';

/// Text and icon formatting shared by the offer card and the detail sheet.
abstract final class OfferFormat {
  /// "2 h 18 min", "45 min", "3 d 4 h".
  static String countdown(Duration left) {
    if (left.isNegative) return 'Finalizada';
    final days = left.inDays;
    final hours = left.inHours % 24;
    final minutes = left.inMinutes % 60;
    if (days > 0) return '$days d $hours h';
    if (left.inHours > 0) return '${left.inHours} h $minutes min';
    return '${minutes < 1 ? 1 : minutes} min';
  }

  /// "Bs 40", "Bs 12.50".
  static String price(double value, String currency) {
    final text = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$currency $text';
  }

  static String distance(double meters) => meters < 1000
      ? '${(meters / 10).round() * 10} m'
      : '${(meters / 1000).toStringAsFixed(1)} km';

  /// Badge text: "-20%", or the amount off when no percentage is computable.
  static String badge(OfferDetail offer) {
    final percent = offer.discountPercent;
    if (percent != null && percent > 0) return '-$percent%';
    if (offer.discountType == DiscountType.fixedAmount) {
      return '-${price(offer.discountValue, offer.currency)}';
    }
    return 'Oferta';
  }

  static const _months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  static String _hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  /// "Válido hoy hasta las 23:00", "Válido hasta mañana 18:00",
  /// "Válido hasta el 3 nov".
  static String validity(OfferDetail offer, DateTime now) {
    final end = offer.endsAt(now);
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(end.year, end.month, end.day);
    final days = endDay.difference(today).inDays;
    if (days <= 0) return 'Válido hoy hasta las ${_hhmm(end)}';
    if (days == 1) return 'Válido hasta mañana ${_hhmm(end)}';
    return 'Válido hasta el ${end.day} ${_months[end.month - 1]}';
  }

  /// Category icon from its stored Material code point (`0xe532`).
  static IconData categoryIcon(String? iconHex) {
    if (iconHex == null || iconHex.isEmpty) return Icons.storefront;
    final clean = iconHex.startsWith('0x') ? iconHex.substring(2) : iconHex;
    final codePoint = int.tryParse(clean, radix: 16);
    if (codePoint == null) return Icons.storefront;
    // Code point comes from the database, so it can't be const.
    // ignore: non_const_argument_for_const_parameter
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }
}

/// Pink "-20%" pill drawn over offer photos.
class OfferDiscountBadge extends StatelessWidget {
  const OfferDiscountBadge({
    super.key,
    required this.offer,
    this.fontSize = 13,
  });

  final OfferDetail offer;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.offerPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        OfferFormat.badge(offer),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

/// Clock + remaining time chip.
class OfferCountdownChip extends StatelessWidget {
  const OfferCountdownChip({
    super.key,
    required this.left,
    this.urgent = false,
  });

  final Duration left;

  /// Solid red variant used in the detail sheet.
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: urgent
            ? AppColors.offerRed
            : Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            urgent ? Icons.timer_outlined : Icons.schedule,
            size: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            OfferFormat.countdown(left),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Offer photo with a neutral placeholder while loading or when missing.
class OfferImage extends StatelessWidget {
  const OfferImage({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: context.palette.mutedFill,
      child: Center(
        child: Icon(
          Icons.local_offer_outlined,
          size: 36,
          color: context.palette.faint,
        ),
      ),
    );
    if (url == null) return placeholder;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

/// Strike-through original price followed by the discounted price, or the
/// discount itself when the offer isn't linked to a priced item.
class OfferPriceRow extends StatelessWidget {
  const OfferPriceRow({
    super.key,
    required this.offer,
    this.large = false,
    this.finalFirst = false,
  });

  final OfferDetail offer;
  final bool large;

  /// Detail sheet order: "Bs 40  Bs 50" instead of "Bs 50  Bs 40".
  final bool finalFirst;

  @override
  Widget build(BuildContext context) {
    final original = offer.originalPrice;
    final finalPrice = offer.finalPrice;
    final mainStyle = TextStyle(
      color: AppColors.purple,
      fontWeight: FontWeight.w900,
      fontSize: large ? 30 : 20,
      height: 1.1,
    );
    if (original == null || finalPrice == null) {
      return Text(
        _discountText,
        style: mainStyle.copyWith(fontSize: large ? 24 : 17),
      );
    }
    final struck = Text(
      OfferFormat.price(original, offer.currency),
      style: TextStyle(
        color: context.palette.textMuted,
        fontSize: large ? 18 : 13,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.lineThrough,
        decorationColor: context.palette.textMuted,
      ),
    );
    final main = Text(
      OfferFormat.price(finalPrice, offer.currency),
      style: mainStyle,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: finalFirst
          ? [main, const SizedBox(width: 8), struck]
          : [struck, const SizedBox(width: 8), Flexible(child: main)],
    );
  }

  String get _discountText {
    final percent = offer.discountPercent;
    if (percent != null && percent > 0) return '$percent% de descuento';
    return '${OfferFormat.price(offer.discountValue, offer.currency)} de descuento';
  }
}

/// Carousel / grid card of the "Ofertas" tab.
class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.now,
    required this.onTap,
    this.distanceMeters,
  });

  static const double width = 200;
  static const double height = 252;

  final OfferDetail offer;
  final DateTime now;
  final VoidCallback onTap;
  final double? distanceMeters;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  OfferImage(url: offer.imageUrl),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: OfferDiscountBadge(offer: offer),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: OfferCountdownChip(
                      left: offer.endsAt(now).difference(now),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 6, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          OfferFormat.categoryIcon(offer.categoryIcon),
                          size: 14,
                          color: AppColors.purple,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            offer.businessName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        offer.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    OfferPriceRow(offer: offer),
                    const Spacer(),
                    Row(
                      children: [
                        if (distanceMeters != null) ...[
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: palette.textTertiary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            OfferFormat.distance(distanceMeters!),
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                        const Spacer(),
                        FavoriteButton(
                          kind: FavoriteKind.offer,
                          targetId: offer.id,
                          size: 20,
                          onSurface: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
