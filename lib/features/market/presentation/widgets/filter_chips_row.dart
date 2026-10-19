import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';
import 'package:market_app/features/market/presentation/widgets/market_filters_sheet.dart';

import '../../../../core/theme/app_palette.dart';

/// "Filtros · Distancia · Abierto · Ofertas" toggle chips.
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key, required this.onDistanceUnavailable});

  /// Called when "Distancia" is tapped but the user's location is unknown.
  final VoidCallback onDistanceUnavailable;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketCubit>().state;
    final cubit = context.read<MarketCubit>();
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'Filtros',
            leading: const Icon(Icons.tune, size: 18),
            selected: state.hasActiveFilters,
            badgeCount: state.activeFiltersCount,
            onTap: () => showMarketFiltersSheet(
              context: context,
              onDistanceUnavailable: onDistanceUnavailable,
            ),
          ),
          _FilterChip(
            label: 'Distancia',
            leading: const Icon(
              Icons.location_on,
              size: 18,
              color: AppColors.offerRed,
            ),
            selected: state.sortByDistance,
            onTap: state.hasUserLocation
                ? cubit.toggleSortByDistance
                : onDistanceUnavailable,
          ),
          _FilterChip(
            label: 'Abierto',
            leading: const Icon(
              Icons.circle,
              size: 14,
              color: AppColors.badgeGreen,
            ),
            selected: state.openNowOnly,
            onTap: cubit.toggleOpenNow,
          ),
          _FilterChip(
            label: 'Ofertas',
            leading: const Icon(
              Icons.local_fire_department,
              size: 18,
              color: AppColors.flame,
            ),
            selected: state.offersOnly,
            onTap: cubit.toggleOffersOnly,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.leading,
    required this.selected,
    required this.onTap,
    this.badgeCount,
  });

  final String label;
  final Widget leading;
  final bool selected;
  final VoidCallback? onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected
            ? context.palette.purpleSurface
            : context.palette.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? AppColors.purple : context.palette.border,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                leading,
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.purple
                        : context.palette.textPrimary,
                  ),
                ),
                if (badgeCount != null && badgeCount! > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
