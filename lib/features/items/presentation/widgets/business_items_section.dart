import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/item.dart';
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
  });

  final String businessId;

  /// Optional externally-owned cubit. When provided, the parent controls its
  /// lifecycle and can trigger [ItemListCubit.refresh] (e.g. pull-to-refresh).
  /// When null, this widget creates and owns its own cubit.
  final ItemListCubit? cubit;

  /// When provided, a "Ver todas" link is shown next to the filter pills.
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final externalCubit = cubit;
    if (externalCubit != null) {
      return BlocProvider<ItemListCubit>.value(
        value: externalCubit,
        child: _SectionBody(onSeeAll: onSeeAll),
      );
    }
    return BlocProvider<ItemListCubit>(
      create: (context) => ItemListCubit(
        repository: context.read<ItemRepository>(),
        businessId: businessId,
      )..initialize(),
      child: _SectionBody(onSeeAll: onSeeAll),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody({this.onSeeAll});

  final VoidCallback? onSeeAll;

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
            _SectionContent(state: state),
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
  const _SectionContent({required this.state});

  final ItemListState state;

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
    return ItemsList(items: visible);
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
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  const ItemsList({super.key, required this.items, this.shrinkWrap = true});

  final List<Item> items;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => ItemRow(item: items[index]),
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cover = item.images.isNotEmpty ? item.images.first.url : null;
    final description = item.description;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.purpleSurface,
        borderRadius: BorderRadius.circular(14),
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
                      errorBuilder: (_, _, _) => const _CoverPlaceholder(),
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
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatPrice(item.currency, item.price),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String currency, double price) {
    final isWhole = price.truncateToDouble() == price;
    final amount = price.toStringAsFixed(isWhole ? 0 : 2);
    final symbol = switch (currency) {
      'USD' => r'$',
      'BOB' => 'Bs. ',
      _ => '$currency ',
    };
    return '$symbol$amount';
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 24, color: Colors.black38),
    );
  }
}
