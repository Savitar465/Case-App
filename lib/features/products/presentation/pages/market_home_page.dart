import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';
import 'package:market_app/features/products/presentation/bloc/product_catalog_cubit.dart';

class MarketHomePage extends StatefulWidget {
  const MarketHomePage({super.key});

  static const routeName = '/market';

  @override
  State<MarketHomePage> createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  late final ProductCatalogCubit _catalogCubit;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _catalogCubit = ProductCatalogCubit(
      repository: context.read<ProductRepository>(),
    )..refresh();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _catalogCubit.close();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query == _searchQuery) {
      return;
    }
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
      _searchController.clear();
    });
  }

  List<Product> _applyFilters(List<Product> products) {
    final query = _searchQuery.toLowerCase();
    return products.where((product) {
      final categoryLabel = product.category?.trim();
      final matchesCategory =
          _selectedCategory == null ||
          (categoryLabel != null &&
              categoryLabel.toLowerCase() == _selectedCategory?.toLowerCase());
      if (!matchesCategory) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final description = product.description?.toLowerCase() ?? '';
      final unit = product.unit?.toLowerCase() ?? '';
      final name = product.name.toLowerCase();
      final category = product.category?.toLowerCase() ?? '';
      return name.contains(query) ||
          description.contains(query) ||
          unit.contains(query) ||
          category.contains(query);
    }).toList();
  }

  List<String> _availableCategories(List<Product> products) {
    final categories = products
        .map((product) => (product.category ?? 'General').trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
    categories.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _catalogCubit,
      child: BlocListener<ProductCatalogCubit, ProductCatalogState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Market'),
            actions: [
              IconButton(
                tooltip: 'Clear filters',
                onPressed:
                    (_searchQuery.isNotEmpty || _selectedCategory != null)
                    ? _clearFilters
                    : null,
                icon: const Icon(Icons.filter_alt_off_outlined),
              ),
              IconButton(
                tooltip: 'Refresh catalog',
                onPressed: _catalogCubit.refresh,
                icon: const Icon(Icons.refresh_outlined),
              ),
              IconButton(
                tooltip: 'Logout',
                onPressed: () =>
                    context.read<AuthBloc>().add(const LogoutRequested()),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: BlocBuilder<ProductCatalogCubit, ProductCatalogState>(
            builder: (context, state) {
              final categories = _availableCategories(state.products);
              final filtered = _applyFilters(state.products);
              return Column(
                children: [
                  _SearchBar(controller: _searchController),
                  _CategoryFilter(
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    onCategoryTap: _toggleCategory,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _catalogCubit.refresh,
                      child: _CatalogList(
                        state: state,
                        products: filtered,
                        onProductTap: _showProductDetails,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    final message = product.inStock
        ? '“${product.name}” is available for purchase soon.'
        : '“${product.name}” is currently out of stock.';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Search products',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox(height: 8);
    }
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedCategory == category;
          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) => onCategoryTap(category),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}

class _CatalogList extends StatelessWidget {
  const _CatalogList({
    required this.state,
    required this.products,
    required this.onProductTap,
  });

  final ProductCatalogState state;
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoading && state.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final children = <Widget>[];

    if (state.errorMessage != null) {
      children.add(
        Card(
          color: theme.colorScheme.errorContainer,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: ListTile(
            leading: Icon(
              Icons.wifi_off_outlined,
              color: theme.colorScheme.onErrorContainer,
            ),
            title: Text(
              state.errorMessage!,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ),
      );
    }

    if (products.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.store_mall_directory_outlined, size: 64),
              const SizedBox(height: 16),
              Text(
                'No products to show yet',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage != null
                    ? 'We will keep trying to update your catalog.'
                    : 'Please check back soon for new arrivals.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      for (final product in products) {
        children.add(
          _ProductCard(product: product, onTap: () => onProductTap(product)),
        );
      }
    }

    children.add(const SizedBox(height: 80));

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: children,
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[
      Chip(
        label: Text(product.category ?? 'General'),
        avatar: const Icon(Icons.category_outlined, size: 16),
      ),
      Chip(
        label: Text(product.inStock ? 'In stock' : 'Out of stock'),
        avatar: Icon(
          product.inStock ? Icons.check_circle_outline : Icons.error_outline,
          size: 16,
        ),
      ),
      if (product.isTrending)
        Chip(
          label: const Text('Trending'),
          avatar: const Icon(Icons.trending_up, size: 16),
        ),
      if (product.rating != null)
        Chip(
          label: Text(product.rating!.toStringAsFixed(1)),
          avatar: const Icon(Icons.star_border_rounded, size: 16),
        ),
      if (product.syncStatus.isPending)
        Chip(
          label: const Text('Pending sync'),
          avatar: const Icon(Icons.sync_outlined, size: 16),
        ),
    ];

    final updatedAt = product.updatedAt ?? product.createdAt;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    _priceLabel(product),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (product.description != null)
                Text(
                  product.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: chips),
              if (updatedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Updated ${_timeAgo(updatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _priceLabel(Product product) {
    final unit = product.unit?.trim();
    final price = product.price.toStringAsFixed(2);
    const currencyCode = 36; // ASCII for $
    final symbol = String.fromCharCode(currencyCode);
    return unit == null || unit.isEmpty
        ? '$symbol$price'
        : '$symbol$price / $unit';
  }

  static String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'moments ago';
    }
    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    }
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  }
}
