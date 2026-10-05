import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/favorite_kind.dart';

/// Labels shared by the favorites tab and the per-kind list page.
extension FavoriteKindLabels on FavoriteKind {
  String get title => switch (this) {
    FavoriteKind.business => 'Negocios favoritos',
    FavoriteKind.service => 'Servicios favoritos',
    FavoriteKind.product => 'Productos favoritos',
    FavoriteKind.offer => 'Ofertas favoritas',
  };

  String get emptyMessage => switch (this) {
    FavoriteKind.business =>
      'Toca el corazón en un negocio para guardarlo aquí.',
    FavoriteKind.service => 'Guarda servicios desde el perfil de un negocio.',
    FavoriteKind.product => 'Guarda productos desde el perfil de un negocio.',
    FavoriteKind.offer => 'Guarda las ofertas que no te quieres perder.',
  };
}

/// One square of the 2×2 "Favoritos" grid: illustration, title and count.
class FavoriteCategoryTile extends StatelessWidget {
  const FavoriteCategoryTile({
    super.key,
    required this.kind,
    required this.count,
    required this.onTap,
  });

  final FavoriteKind kind;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.palette.mutedFill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FavoriteIllustration(kind: kind),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            kind.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            count == 1 ? '1 guardado' : '$count guardados',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon composition standing in for the 3D illustrations of the mockup.
class FavoriteIllustration extends StatelessWidget {
  const FavoriteIllustration({super.key, required this.kind, this.scale = 1});

  final FavoriteKind kind;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final (main, mainColor, accent, accentColor) = switch (kind) {
      FavoriteKind.business => (
        Icons.storefront_rounded,
        AppColors.purple,
        Icons.eco_rounded,
        const Color(0xFF3BA55C),
      ),
      FavoriteKind.service => (
        Icons.medical_services_rounded,
        // Slate navy disappears on the dark tile; use a lighter slate there.
        Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF8D93B8)
            : const Color(0xFF3A3F5C),
        Icons.fitness_center_rounded,
        AppColors.purple,
      ),
      FavoriteKind.product => (
        Icons.shopping_bag_rounded,
        AppColors.purple,
        Icons.inventory_2_rounded,
        const Color(0xFFE0A24E),
      ),
      FavoriteKind.offer => (
        Icons.local_fire_department_rounded,
        AppColors.flame,
        Icons.percent_rounded,
        AppColors.purple,
      ),
    };
    return Center(
      child: SizedBox(
        width: 96 * scale,
        height: 96 * scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Icon(main, size: 80 * scale, color: mainColor),
            ),
            Positioned(
              right: -4 * scale,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(5 * scale),
                decoration: BoxDecoration(
                  color: context.palette.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: context.palette.shadow, blurRadius: 6),
                  ],
                ),
                child: Icon(accent, size: 26 * scale, color: accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
