import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';

export 'home_search_field.dart';

/// "📍 Pando ⌄" location label plus the notifications bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onLocationTap});

  final VoidCallback onLocationTap;

  @override
  Widget build(BuildContext context) {
    final label = context.select((MarketCubit c) => c.state.locationLabel);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onLocationTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.purple,
                    size: 22,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 22),
                ],
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No tienes notificaciones nuevas')),
            ),
            icon: const Icon(Icons.notifications_none_rounded, size: 28),
          ),
        ],
      ),
    );
  }
}

/// Section heading with an optional leading icon and trailing badge.
class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.trailing,
  });

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
