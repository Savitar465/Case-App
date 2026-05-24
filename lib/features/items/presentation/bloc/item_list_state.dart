part of 'item_list_cubit.dart';

enum ItemTypeFilter { all, products, services }

class ItemListState extends Equatable {
  const ItemListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.filter = ItemTypeFilter.products,
  });

  final List<Item> items;
  final bool isLoading;
  final String? error;
  final ItemTypeFilter filter;

  List<Item> get visibleItems {
    switch (filter) {
      case ItemTypeFilter.products:
        return items.where((i) => i.type == ItemType.product).toList();
      case ItemTypeFilter.services:
        return items.where((i) => i.type == ItemType.service).toList();
      case ItemTypeFilter.all:
        return items;
    }
  }

  ItemListState copyWith({
    List<Item>? items,
    bool? isLoading,
    String? error,
    ItemTypeFilter? filter,
    bool clearError = false,
  }) {
    return ItemListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error, filter];
}
