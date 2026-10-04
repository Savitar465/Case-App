import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';

/// Horizontal row of category tiles ending in "Ver más".
class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key});

  static const int _visibleCount = 5;

  @override
  Widget build(BuildContext context) {
    final state = context
        .watch<MarketCubit>()
        .state;
    final categories = state.categories
        .where((c) => c.name != 'Otros')
        .toList();
    final visible = categories.take(_visibleCount).toList();
    final selected = state.selectedCategoryId;
    // Keep a selected category picked from "Ver más" visible in the strip.
    if (selected != null && visible.every((c) => c.id != selected)) {
      final match = categories.where((c) => c.id == selected);
      if (match.isNotEmpty) visible[visible.length - 1] = match.first;
    }

    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          for (final category in visible)
            _CategoryTile(
              label: category.nameEs,
              style: _CategoryStyle.of(category),
              selected: category.id == selected,
              onTap: () =>
                  context.read<MarketCubit>().selectCategory(category.id),
            ),
          _CategoryTile(
            label: 'Ver más',
            style: const _CategoryStyle(Icons.grid_view_rounded, Colors.grey),
            selected: false,
            onTap: () => _showAll(context, categories),
          ),
        ],
      ),
    );
  }

  void _showAll(BuildContext context, List<MarketCategory> categories) {
    final cubit = context.read<MarketCubit>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) =>
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Wrap(
                spacing: 4,
                runSpacing: 12,
                children: [
                  for (final category in categories)
                    _CategoryTile(
                      label: category.nameEs,
                      style: _CategoryStyle.of(category),
                      selected: category.id == cubit.state.selectedCategoryId,
                      onTap: () {
                        cubit.selectCategory(category.id);
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }
}

class _CategoryStyle {
  const _CategoryStyle(this.icon, this.color);

  final IconData icon;
  final Color color;

  /// Maps the category's English key to the illustrated look of the design.
  /// Uses const icons only so release builds can tree-shake the icon font.
  static _CategoryStyle of(MarketCategory category) {
    return switch (category.name) {
      'food' => const _CategoryStyle(Icons.lunch_dining, Color(0xFFFF8A00)),
      'education' => const _CategoryStyle(Icons.school, Color(0xFF3949AB)),
      'health' => const _CategoryStyle(Icons.monitor_heart, Color(0xFFE53935)),
      'entertainment' =>
      const _CategoryStyle(
        Icons.movie_filter,
        Color(0xFFD81B60),
      ),
      'sports' => const _CategoryStyle(Icons.fitness_center, Color(0xFF455A64)),
      'technology' => const _CategoryStyle(Icons.devices, Color(0xFF00897B)),
      'travel' => const _CategoryStyle(Icons.flight, Color(0xFF039BE5)),
      'music' => const _CategoryStyle(Icons.music_note, Color(0xFF8E24AA)),
      'shopping' => const _CategoryStyle(Icons.shopping_bag, Color(0xFF6D4C41)),
      'finance' => const _CategoryStyle(Icons.savings, Color(0xFF2E7D32)),
      _ => const _CategoryStyle(Icons.storefront, AppColors.purple),
    };
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final _CategoryStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: selected ? AppColors.purpleSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.purple : const Color(0xFFEDE8F3),
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(style.icon, color: style.color, size: 30),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.purple : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
