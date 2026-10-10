import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/core/theme/app_palette.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';

/// Shows the bottom sheet modal for filtering businesses in the market.
Future<void> showMarketFiltersSheet({
  required BuildContext context,
  VoidCallback? onDistanceUnavailable,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: context.read<MarketCubit>(),
      child: MarketFiltersSheet(onDistanceUnavailable: onDistanceUnavailable),
    ),
  );
}

class MarketFiltersSheet extends StatefulWidget {
  const MarketFiltersSheet({super.key, this.onDistanceUnavailable});

  final VoidCallback? onDistanceUnavailable;

  @override
  State<MarketFiltersSheet> createState() => _MarketFiltersSheetState();
}

class _MarketFiltersSheetState extends State<MarketFiltersSheet> {
  late double _distanceValue;
  late bool _openNow;
  late bool _offersOnly;
  String? _selectedPriceTier;
  String? _selectedCategoryId;
  late List<MarketCategory> _categories;

  @override
  void initState() {
    super.initState();
    final state = context.read<MarketCubit>().state;
    _categories = state.categories.where((c) => c.name != 'Otros').toList();
    _distanceValue = state.maxDistanceKm ?? 5.0;
    _openNow = state.openNowOnly;
    _offersOnly = state.offersOnly;
    _selectedPriceTier = state.priceTier;
    _selectedCategoryId = state.selectedCategoryId;
  }

  void _resetFilters() {
    setState(() {
      _distanceValue = 5.0;
      _openNow = false;
      _offersOnly = false;
      _selectedPriceTier = null;
      _selectedCategoryId = null;
    });
  }

  void _applyFilters() {
    final cubit = context.read<MarketCubit>();
    final maxDist = _distanceValue >= 5.0 ? null : _distanceValue;
    if (maxDist != null && !cubit.state.hasUserLocation) {
      widget.onDistanceUnavailable?.call();
    }
    cubit.applyFilters(
      openNowOnly: _openNow,
      offersOnly: _offersOnly,
      maxDistanceKm: maxDist,
      clearMaxDistance: maxDist == null,
      priceTier: _selectedPriceTier,
      clearPriceTier: _selectedPriceTier == null,
      selectedCategoryId: _selectedCategoryId,
      clearSelectedCategory: _selectedCategoryId == null,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: palette.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.faint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _Header(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              _DistanceSection(
                value: _distanceValue,
                onChanged: (val) => setState(() => _distanceValue = val),
              ),
              if (_categories.isNotEmpty) ...[
                const SizedBox(height: 20),
                const _SectionTitle(title: 'Categorías'),
                const SizedBox(height: 10),
                _CategorySelector(
                  categories: _categories,
                  selectedId: _selectedCategoryId,
                  onSelected: (id) {
                    setState(() {
                      _selectedCategoryId =
                          _selectedCategoryId == id ? null : id;
                    });
                  },
                ),
              ],
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Estado del negocio'),
              const SizedBox(height: 10),
              _ToggleCard(
                icon: Icons.storefront_rounded,
                iconColor: const Color(0xFF22C55E),
                iconBgColor: const Color(0xFF0F392B),
                title: 'Abierto ahora',
                value: _openNow,
                activeColor: const Color(0xFF22C55E),
                onChanged: (val) => setState(() => _openNow = val),
              ),
              const SizedBox(height: 20),
              _SectionTitle(title: 'Ofertas'),
              const SizedBox(height: 10),
              _ToggleCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.flame,
                iconBgColor: const Color(0xFF422110),
                title: 'Solo con ofertas',
                value: _offersOnly,
                activeColor: const Color(0xFF22C55E),
                onChanged: (val) => setState(() => _offersOnly = val),
              ),
              const SizedBox(height: 20),
              _SectionTitle(title: 'Precio'),
              const SizedBox(height: 10),
              _PriceTierSelector(
                selectedTier: _selectedPriceTier,
                onSelected: (tier) {
                  setState(() {
                    _selectedPriceTier = _selectedPriceTier == tier ? null : tier;
                  });
                },
              ),
              const SizedBox(height: 28),
              _FooterButtons(
                onClear: _resetFilters,
                onApply: _applyFilters,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filtros',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: context.palette.textPrimary,
          ),
        ),
        Material(
          color: context.palette.mutedFill,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                size: 20,
                color: context.palette.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.palette.textPrimary,
      ),
    );
  }
}

class _DistanceSection extends StatelessWidget {
  const _DistanceSection({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isAny = value >= 5.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title: 'Distancia máxima'),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.purple,
            inactiveTrackColor: palette.neutralBorder,
            thumbColor: AppColors.purple,
            overlayColor: AppColors.purple.withValues(alpha: 0.15),
            trackHeight: 5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.5),
            activeTickMarkColor: Colors.white70,
            inactiveTickMarkColor: palette.faint,
          ),
          child: Slider(
            value: value.clamp(0.5, 5.0),
            min: 0.5,
            max: 5.0,
            divisions: 9,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.5 km',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: palette.textTertiary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.purpleSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isAny ? 'Cualquier distancia' : '${value.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.purple,
                  ),
                ),
              ),
              Text(
                '5 km',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: palette.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.mutedFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.neutralBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: activeColor,
            activeTrackColor: activeColor.withValues(alpha: 0.45),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: palette.border,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PriceTierSelector extends StatelessWidget {
  const _PriceTierSelector({
    required this.selectedTier,
    required this.onSelected,
  });

  final String? selectedTier;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tiers = [
      ('economic', 'Económico (\$)'),
      ('medium', 'Medio (\$\$)'),
      ('premium', 'Premium (\$\$\$)'),
    ];

    return Row(
      children: [
        for (var i = 0; i < tiers.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _PriceTierChip(
              label: tiers[i].$2,
              isSelected: selectedTier == tiers[i].$1,
              onTap: () => onSelected(tiers[i].$1),
            ),
          ),
        ],
      ],
    );
  }
}

class _PriceTierChip extends StatelessWidget {
  const _PriceTierChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: isSelected ? palette.purpleSurface : palette.mutedFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.purple : palette.neutralBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.purple : palette.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({
    required this.onClear,
    required this.onApply,
  });

  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          child: Text(
            'Limpiar filtros',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.palette.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: const Text(
              'Aplicar filtros',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<MarketCategory> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in categories)
          _CategoryChip(
            category: category,
            isSelected: category.id == selectedId,
            onTap: () => onSelected(category.id),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final MarketCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  IconData _iconFor(String name) {
    return switch (name) {
      'food' => Icons.lunch_dining,
      'education' => Icons.school,
      'health' => Icons.monitor_heart,
      'entertainment' => Icons.movie_filter,
      'sports' => Icons.fitness_center,
      'technology' => Icons.devices,
      'travel' => Icons.flight,
      'music' => Icons.music_note,
      'shopping' => Icons.shopping_bag,
      'finance' => Icons.savings,
      _ => Icons.storefront,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: isSelected ? palette.purpleSurface : palette.mutedFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.purple : palette.neutralBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconFor(category.name),
                size: 16,
                color: isSelected ? AppColors.purple : palette.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                category.nameEs,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.purple : palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
