import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/contact_launcher.dart';
import '../../../favorites/domain/entities/favorite_kind.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/offer_detail.dart';
import 'offer_card.dart';

/// Bottom sheet with the offer photo, price, validity and the WhatsApp CTA.
Future<void> showOfferDetailSheet(BuildContext context, OfferDetail offer) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _OfferDetailSheet(offer: offer),
  );
}

class _OfferDetailSheet extends StatelessWidget {
  const _OfferDetailSheet({required this.offer});

  final OfferDetail offer;

  void _contact(BuildContext context, String whatsapp) {
    ContactLauncher.openWhatsApp(
      context,
      whatsapp,
      message:
          'Hola, vi la oferta "${offer.title}" en la app y me gustaría '
          'aprovecharla.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final now = DateTime.now();
    final whatsapp = offer.businessWhatsapp?.trim();
    final hasWhatsapp = whatsapp != null && whatsapp.isNotEmpty;
    final stock = offer.stock;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  OfferImage(url: offer.imageUrl),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: OfferDiscountBadge(offer: offer, fontSize: 14),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Cerrar',
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: OfferCountdownChip(
                      left: offer.endsAt(now).difference(now),
                      urgent: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: palette.purpleSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    offer.categoryName ?? offer.businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (stock != null)
                Text(
                  stock == 1 ? 'Queda 1 disponible' : '$stock disponibles',
                  style: const TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            offer.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            offer.businessName,
            style: TextStyle(fontSize: 15, color: palette.textSecondary),
          ),
          if (offer.description.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              offer.description.trim(),
              style: TextStyle(color: palette.textSecondary, height: 1.35),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              OfferPriceRow(offer: offer, large: true, finalFirst: true),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.offerRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: AppColors.offerRed,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      OfferFormat.validity(offer, now),
                      style: const TextStyle(
                        color: AppColors.offerRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: palette.neutralBorder),
                ),
                alignment: Alignment.center,
                child: FavoriteButton(
                  kind: FavoriteKind.offer,
                  targetId: offer.id,
                  size: 24,
                  onSurface: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: hasWhatsapp
                        ? () => _contact(context, whatsapp)
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.badgeGreen,
                      disabledBackgroundColor: palette.mutedFill,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    icon: const Icon(Icons.chat),
                    label: Text(hasWhatsapp ? 'WhatsApp' : 'Sin WhatsApp'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
