import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';
import 'package:market_app/features/business/presentation/pages/business_profile_page.dart';
import 'package:market_app/features/market/domain/entities/business.dart';

/// Loads the full business and pushes its profile page.
Future<void> openBusinessProfile(BuildContext context,
    String businessId,) async {
  final repository = context.read<BusinessRepository>();
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);

  try {
    final fullBusiness = await repository.getBusiness(businessId);
    if (fullBusiness == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo cargar el negocio')),
      );
      return;
    }
    await navigator.push(
      MaterialPageRoute(
        builder: (_) => BusinessProfilePage(business: fullBusiness),
      ),
    );
  } catch (error) {
    debugPrint('openBusinessProfile failed: $error');
    messenger.showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el negocio')),
    );
  }
}

String _distanceLabel(double meters) =>
    meters < 1000
        ? '${(meters / 10).round() * 10} m de ti'
        : '${(meters / 1000).toStringAsFixed(1)} km de ti';

/// Horizontal card used in "Negocios cerca de ti" (image left, info right).
class NearbyBusinessCard extends StatelessWidget {
  const NearbyBusinessCard({
    super.key,
    required this.business,
    required this.isFavorite,
    required this.onFavorite,
    this.distanceMeters,
    this.hasOffer = false,
  });

  final Business business;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final double? distanceMeters;
  final bool hasOffer;

  @override
  Widget build(BuildContext context) {
    final location = [
      if (business.address.isNotEmpty) business.address,
      if (distanceMeters != null) _distanceLabel(distanceMeters!),
    ].join(' - ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: _CardSurface(
        onTap: () => openBusinessProfile(context, business.id),
        child: SizedBox(
          height: 138,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _Cover(url: business.coverUrl),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: _FavoriteButton(
                        isFavorite: isFavorite,
                        onPressed: onFavorite,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Avatar(business: business),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              business.name.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (hasOffer) const _OfferBadge(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _RatingRow(business: business),
                      if ((business.description ?? '').isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          business.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (location.isNotEmpty)
                        _IconLine(
                          icon: Icons.location_on,
                          color: AppColors.offerRed,
                          text: location,
                        ),
                      const SizedBox(height: 2),
                      _OpenStatus(business: business, showClosingTime: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vertical card used in the "Negocios destacados" PRO row.
class FeaturedBusinessCard extends StatelessWidget {
  const FeaturedBusinessCard({
    super.key,
    required this.business,
    this.distanceMeters,
  });

  final Business business;
  final double? distanceMeters;

  @override
  Widget build(BuildContext context) {
    final location = distanceMeters != null
        ? 'A ${_distanceLabel(distanceMeters!).replaceAll(' de ti', '')}'
        : business.address;

    return SizedBox(
      width: 172,
      child: _CardSurface(
        onTap: () => openBusinessProfile(context, business.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 112,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Cover(url: business.coverUrl),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.flame,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _IconLine(
                    icon: Icons.location_on,
                    color: AppColors.offerRed,
                    text: location,
                  ),
                  const SizedBox(height: 2),
                  _OpenStatus(business: business, showClosingTime: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.purpleSurface,
      child: Center(
        child: Icon(Icons.storefront, color: AppColors.purple, size: 36),
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final logo = business.imageUrls.length > 1 ? business.imageUrls[1] : null;
    final initial = business.name.isEmpty ? '?' : business.name[0];
    return CircleAvatar(
      radius: 13,
      backgroundColor: const Color(0xFF5F5F68),
      foregroundImage: logo == null ? null : NetworkImage(logo),
      onForegroundImageError: logo == null ? null : (_, _) {},
      child: Text(
        initial.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: isFavorite ? AppColors.offerRed : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final rating = business.rating;
    if (business.reviewCount == 0) {
      return const Text(
        'Sin opiniones aún',
        style: TextStyle(fontSize: 12, color: Colors.black45),
      );
    }
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            rating >= i
                ? Icons.star_rounded
                : rating >= i - 0.5
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            size: 16,
            color: AppColors.star,
          ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '(${business.reviewCount} opiniones)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _OpenStatus extends StatelessWidget {
  const _OpenStatus({required this.business, required this.showClosingTime});

  final Business business;
  final bool showClosingTime;

  @override
  Widget build(BuildContext context) {
    final hours = business.openingHours;
    if (!hours.isKnown) return const SizedBox.shrink();
    final range = hours.currentRange(DateTime.now());
    final isOpen = range != null;
    final color = isOpen ? AppColors.badgeGreen : AppColors.offerRed;
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 6),
        Text(
          isOpen ? 'Abierto' : 'Cerrado',
          style: TextStyle(
            fontSize: 11.5,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isOpen && showClosingTime)
          Flexible(
            child: Text(
              ' · Cierra a las ${range.closeLabel}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5, color: Colors.black87),
            ),
          ),
      ],
    );
  }
}

class _OfferBadge extends StatelessWidget {
  const _OfferBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.flame,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'OFERTA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
