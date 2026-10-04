import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';

/// "Filtros · Distancia · Abierto · Ofertas" toggle chips.
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key, required this.onDistanceUnavailable});

  /// Called when "Distancia" is tapped but the user's location is unknown.
  final VoidCallback onDistanceUnavailable;

  @override
  Widget build(BuildContext context) {
    final state = context
        .watch<MarketCubit>()
        .state;
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
            onTap: state.hasActiveFilters ? cubit.clearFilters : null,
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
  });

  final String label;
  final Widget leading;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? AppColors.purpleSurface : Colors.white,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? AppColors.purple : const Color(0xFFDCD5E5),
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
                    color: selected ? AppColors.purple : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
