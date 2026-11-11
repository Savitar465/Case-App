part of 'item_list_cubit.dart';

enum ItemTypeFilter { all, products, services }

class ItemListState extends Equatable {
  const ItemListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.filter = ItemTypeFilter.products,
    this.hasExplicitFilter = false,
  });

  final List<Item> items;
  final bool isLoading;
  final String? error;
  final ItemTypeFilter filter;
  final bool hasExplicitFilter;

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
    bool? hasExplicitFilter,
    bool clearError = false,
  }) {
    return ItemListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      filter: filter ?? this.filter,
      hasExplicitFilter: hasExplicitFilter ?? this.hasExplicitFilter,
    );
  }

  @override
  List<Object?> get props => [
    items,
    isLoading,
    error,
    filter,
    hasExplicitFilter,
  ];
}
