import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/favorite_kind.dart';
import '../bloc/favorites_cubit.dart';

/// Heart toggle bound to the app-wide [FavoritesCubit].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.kind,
    required this.targetId,
    this.size = 18,
    this.onSurface = true,
  });

  final FavoriteKind kind;
  final String targetId;
  final double size;

  /// White circle behind the icon, for hearts drawn over photos.
  final bool onSurface;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select(
      (FavoritesCubit c) => c.state.isFavorite(kind, targetId),
    );
    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        key: ValueKey(isFavorite),
        size: size,
        color: isFavorite
            ? AppColors.offerRed
            // The white bubble stays white in dark mode, so keep a dark icon.
            : (onSurface ? Colors.black87 : context.palette.textPrimary),
      ),
    );
    return Semantics(
      button: true,
      toggled: isFavorite,
      label: isFavorite ? 'Quitar de favoritos' : 'Guardar en favoritos',
      child: Material(
        color: onSurface ? Colors.white : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.read<FavoritesCubit>().toggle(kind, targetId),
          child: Padding(padding: const EdgeInsets.all(6), child: icon),
        ),
      ),
    );
  }
}
