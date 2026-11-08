import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../favorites/domain/entities/favorite_kind.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_type.dart';
import '../../domain/repositories/item_repository.dart';
import '../bloc/item_list_cubit.dart';

/// Items list (Productos / Servicios) embedded inside a parent scroll view.
///
/// Owns its own [ItemListCubit] scoped to [businessId] unless one is supplied.
/// Uses shrink-wrap so it can sit inside a `SingleChildScrollView` (e.g.
/// BusinessProfilePage).
class BusinessItemsSection extends StatelessWidget {
  const BusinessItemsSection({
    super.key,
    required this.businessId,
    this.cubit,
    this.onSeeAll,
    this.asCards = true,
    this.selectedItemId,
    this.selectedItemIds = const {},
    this.onItemTap,
  });

  final String businessId;

  /// Optional externally-owned cubit. When provided, the parent controls its
  /// lifecycle and can trigger [ItemListCubit.refresh] (e.g. pull-to-refresh).
  /// When null, this widget creates and owns its own cubit.
  final ItemListCubit? cubit;

  /// When provided, a "Ver todas" link is shown next to the filter pills.
  final VoidCallback? onSeeAll;

  /// When true, items are rendered as a horizontal scroll of cards.
  /// When false, items are rendered as a vertical list of rows.
  final bool asCards;

  /// ID of a single selected item (convenience parameter).
  final String? selectedItemId;

  /// Set of selected item IDs (for multi-selection).
  final Set<String> selectedItemIds;

  /// Called when an item card or row is tapped.
  final ValueChanged<Item>? onItemTap;

  Set<String> get _effectiveSelectedIds => selectedItemId != null
      ? {...selectedItemIds, selectedItemId!}
      : selectedItemIds;

  @override
  Widget build(BuildContext context) {
    final effectiveIds = _effectiveSelectedIds;
    final externalCubit = cubit;
    if (externalCubit != null) {
      return BlocProvider<ItemListCubit>.value(
        value: externalCubit,
        child: _SectionBody(
          onSeeAll: onSeeAll,
          asCards: asCards,
          selectedItemIds: effectiveIds,
          onItemTap: onItemTap,
        ),
      );
    }
    return BlocProvider<ItemListCubit>(
      create: (context) => ItemListCubit(
        repository: context.read<ItemRepository>(),
        businessId: businessId,
      )..initialize(),
      child: _SectionBody(
        onSeeAll: onSeeAll,
        asCards: asCards,
        selectedItemIds: effectiveIds,
        onItemTap: onItemTap,
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody({
    this.onSeeAll,
    this.asCards = true,
    this.selectedItemIds = const {},
    this.onItemTap,
  });

  final VoidCallback? onSeeAll;
  final bool asCards;
  final Set<String> selectedItemIds;
  final ValueChanged<Item>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListCubit, ItemListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ItemTypeTabs(
                    filter: state.filter,
                    onChanged: context.read<ItemListCubit>().selectFilter,
                  ),
                ),
                if (onSeeAll != null) _SeeAllLink(onTap: onSeeAll!),
              ],
            ),
            const SizedBox(height: 12),
            _SectionContent(
              state: state,
              asCards: asCards,
              selectedItemIds: selectedItemIds,
              onItemTap: onItemTap,
            ),
          ],
        );
      },
    );
  }
}

class _SeeAllLink extends StatelessWidget {
  const _SeeAllLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ver todas',
              style: TextStyle(
                color: AppColors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.purple, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({
    required this.state,
    this.asCards = true,
    this.selectedItemIds = const {},
    this.onItemTap,
  });

  final ItemListState state;
  final bool asCards;
  final Set<String> selectedItemIds;
  final ValueChanged<Item>? onItemTap;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.error != null && state.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text(state.error!)),
      );
    }
    final visible = state.visibleItems;
    if (visible.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('No hay elementos para mostrar')),
      );
    }
    if (asCards) {
      return ItemsCardsCarousel(
        items: visible,
        selectedItemIds: selectedItemIds,
        onItemTap: onItemTap,
      );
    }
    return ItemsList(
      items: visible,
      selectedItemIds: selectedItemIds,
      onItemTap: onItemTap,
    );
  }
}

class ItemTypeTabs extends StatelessWidget {
  const ItemTypeTabs({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  final ItemTypeFilter filter;
  final ValueChanged<ItemTypeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    // [filter] may be [ItemTypeFilter.all]; in that case no pill reads as
    // selected, which is fine for the two-pill toggle.
    return Wrap(
      spacing: 8,
      children: [
        _Pill(
          label: 'Servicios',
          value: ItemTypeFilter.services,
          filter: filter,
          onChanged: onChanged,
        ),
        _Pill(
          label: 'Productos',
          value: ItemTypeFilter.products,
          filter: filter,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.value,
    required this.filter,
    required this.onChanged,
  });

  final String label;
  final ItemTypeFilter value;
  final ItemTypeFilter filter;
  final ValueChanged<ItemTypeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = filter == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : context.palette.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ItemsCardsCarousel extends StatelessWidget {
  const ItemsCardsCarousel({
    super.key,
    required this.items,
    this.selectedItemIds = const {},
    this.onItemTap,
  });

  final List<Item> items;
  final Set<String> selectedItemIds;
  final ValueChanged<Item>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemCard(
            item: item,
            isSelected: selectedItemIds.contains(item.id),
            onTap: onItemTap != null ? () => onItemTap!(item) : null,
          );
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    this.width = 175,
    this.isSelected = false,
    this.onTap,
  });

  final Item item;
  final double width;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cover = item.images.isNotEmpty ? item.images.first.url : null;
    final description = item.description;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.purple.withValues(alpha: 0.15)
              : context.palette.purpleSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.purple : context.palette.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 115,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (cover != null)
                    Image.network(
                      cover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _CoverPlaceholder(),
                    )
                  else
                    const _CoverPlaceholder(),
                  if (isSelected)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: FavoriteButton(
                      kind: item.type == ItemType.service
                          ? FavoriteKind.service
                          : FavoriteKind.product,
                      targetId: item.id,
                      onSurface: false,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    formatItemPrice(item.currency, item.price),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  const ItemsList({
    super.key,
    required this.items,
    this.shrinkWrap = true,
    this.selectedItemIds = const {},
    this.onItemTap,
  });

  final List<Item> items;
  final bool shrinkWrap;
  final Set<String> selectedItemIds;
  final ValueChanged<Item>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemRow(
          item: item,
          isSelected: selectedItemIds.contains(item.id),
          onTap: onItemTap != null ? () => onItemTap!(item) : null,
        );
      },
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  final Item item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cover = item.images.isNotEmpty ? item.images.first.url : null;
    final description = item.description;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.purple.withValues(alpha: 0.15)
              : context.palette.purpleSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.purple : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: cover != null
                    ? Image.network(
                        cover,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const _CoverPlaceholder(),
                      )
                    : const _CoverPlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatItemPrice(item.currency, item.price),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle, color: AppColors.purple, size: 20),
            ],
            FavoriteButton(
              kind: item.type == ItemType.service
                  ? FavoriteKind.service
                  : FavoriteKind.product,
              targetId: item.id,
              onSurface: false,
            ),
          ],
        ),
      ),
    );
  }
}

String formatItemPrice(String currency, double price) {
  final isWhole = price.truncateToDouble() == price;
  final amount = price.toStringAsFixed(isWhole ? 0 : 2);
  final symbol = switch (currency) {
    'USD' => r'$',
    'BOB' => 'Bs. ',
    _ => '$currency ',
  };
  return '$symbol$amount';
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.palette.mutedFill,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 24,
        color: context.palette.textMuted,
      ),
    );
  }
}
