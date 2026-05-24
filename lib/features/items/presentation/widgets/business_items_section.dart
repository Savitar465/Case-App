import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../../domain/repositories/item_repository.dart';
import '../bloc/item_list_cubit.dart';

/// Items grid (Productos / Servicios) embedded inside a parent scroll view.
///
/// Owns its own [ItemListCubit] scoped to [businessId]. Uses shrink-wrap so it
/// can sit inside a `SingleChildScrollView` (e.g. BusinessProfilePage).
class BusinessItemsSection extends StatelessWidget {
  const BusinessItemsSection({super.key, required this.businessId, this.cubit});

  final String businessId;

  /// Optional externally-owned cubit. When provided, the parent controls its
  /// lifecycle and can trigger [ItemListCubit.refresh] (e.g. pull-to-refresh).
  /// When null, this widget creates and owns its own cubit.
  final ItemListCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final externalCubit = cubit;
    if (externalCubit != null) {
      return BlocProvider<ItemListCubit>.value(
        value: externalCubit,
        child: const _SectionBody(),
      );
    }
    return BlocProvider<ItemListCubit>(
      create: (context) => ItemListCubit(
        repository: context.read<ItemRepository>(),
        businessId: businessId,
      )..initialize(),
      child: const _SectionBody(),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListCubit, ItemListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemTypeTabs(
              filter: state.filter,
              onChanged: context.read<ItemListCubit>().selectFilter,
            ),
            const SizedBox(height: 8),
            _SectionContent(state: state),
          ],
        );
      },
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
    return ItemsGrid(items: visible);
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
    return Row(
      children: [
        _Tab(
          label: 'Productos',
          value: ItemTypeFilter.products,
          filter: filter,
          onChanged: onChanged,
        ),
        const SizedBox(width: 24),
        _Tab(
          label: 'Servicios',
          value: ItemTypeFilter.services,
          filter: filter,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
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
    final theme = Theme.of(context);
    final selected = filter == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 2,
            width: 64,
            color: selected ? theme.colorScheme.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class ItemsGrid extends StatelessWidget {
  const ItemsGrid({super.key, required this.items, this.shrinkWrap = true});

  final List<Item> items;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => ItemCard(item: items[index]),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cover = item.images.isNotEmpty ? item.images.first.url : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (cover != null)
                  Image.network(
                    cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _CoverPlaceholder(),
                  )
                else
                  const _CoverPlaceholder(),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 2),
        Text(
          _formatPrice(item.currency, item.price),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatPrice(String currency, double price) {
    final isWhole = price.truncateToDouble() == price;
    final amount = price.toStringAsFixed(isWhole ? 0 : 2);
    final symbol = switch (currency) {
      'USD' => r'$',
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
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 32),
    );
  }
}
