import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/inventory/domain/entities/employee.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_location.dart';
import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/entities/seller.dart';
import 'package:market_app/features/products/presentation/bloc/product_editor_cubit.dart';
import 'package:market_app/features/products/presentation/bloc/seller_inventory_cubit.dart';

class SellerProductsPage extends StatefulWidget {
  const SellerProductsPage({
    super.key,
    required this.session,
    required this.seller,
    required this.onReloadSeller,
    this.employee,
    this.location,
    this.contextError,
  });

  final AuthSession session;
  final Seller seller;
  final VoidCallback onReloadSeller;
  final Employee? employee;
  final InventoryLocation? location;
  final String? contextError;

  @override
  State<SellerProductsPage> createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reloadInventory();
    });
  }

  @override
  void didUpdateWidget(covariant SellerProductsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLocationId = oldWidget.location?.id;
    final newLocationId = widget.location?.id;
    if (oldLocationId != newLocationId ||
        widget.seller.id != oldWidget.seller.id) {
      _reloadInventory();
    }
  }

  Future<void> _reloadInventory() async {
    if (!mounted) {
      return;
    }
    final cubit = context.read<SellerInventoryCubit>();
    final location = widget.location;
    if (location == null) {
      cubit.clear();
      return;
    }
    await cubit.loadForLocation(sellerId: widget.seller.id, location: location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = widget.location;
    final employee = widget.employee;
    final contextError = widget.contextError;

    return BlocListener<ProductEditorCubit, ProductEditorState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure ||
          previous.lastAction != current.lastAction,
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.failure!.message)));
          return;
        }
        if (state.lastAction == ProductEditorAction.saved) {
          final pendingLabel =
              state.draft?.syncStatus == ProductSyncStatus.pendingUpsert
              ? 'Saved locally. Will sync when online.'
              : 'Product saved.';
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(pendingLabel)));
          _reloadInventory();
        } else if (state.lastAction == ProductEditorAction.deleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Product deleted.')));
          _reloadInventory();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.seller.storeName),
              Text(
                widget.session.user.email,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (location != null)
                Text(
                  'Ubicacion: ${location.name}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              if (employee != null)
                Text(
                  'Responsable: ${employee.displayName}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Actualizar inventario',
              icon: const Icon(Icons.refresh),
              onPressed: () => _reloadInventory(),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'reload_seller') {
                  widget.onReloadSeller();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'reload_seller',
                  child: Text('Reload seller profile'),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: location == null
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _openEditor(context),
                icon: const Icon(Icons.add),
                label: const Text('Add product'),
              ),

        body: Column(
          children: [
            if (contextError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Card(
                  color: theme.colorScheme.errorContainer,
                  child: ListTile(
                    leading: Icon(
                      Icons.warning_amber_outlined,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    title: const Text(
                      'No se pudo cargar la ubicacion de inventario',
                    ),
                    subtitle: Text(contextError),
                  ),
                ),
              ),
            if (location == null)
              const Expanded(
                child: Center(
                  child: Text('No existe una ubicacion asignada a tu cuenta.'),
                ),
              )
            else ...[
              Builder(
                builder: (context) {
                  final chips = <Widget>[];
                  chips.add(
                    Chip(
                      avatar: const Icon(Icons.location_on_outlined, size: 18),
                      label: Text(
                        '${location.name} - ${location.type == InventoryLocationType.store ? 'Tienda' : 'Almacen'}',
                      ),
                    ),
                  );
                  if (employee != null) {
                    chips.add(
                      Chip(
                        avatar: const Icon(Icons.badge_outlined, size: 18),
                        label: Text(employee.displayName),
                      ),
                    );
                  }
                  final topPadding = contextError != null ? 8.0 : 16.0;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16, topPadding, 16, 0),
                    child: Wrap(spacing: 8, runSpacing: 8, children: chips),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<SellerInventoryCubit, SellerInventoryState>(
                  builder: (context, state) {
                    if (state.isLoading && state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return RefreshIndicator(
                      onRefresh: _reloadInventory,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        children: [
                          if (state.error != null)
                            Card(
                              color: theme.colorScheme.errorContainer,
                              child: ListTile(
                                leading: Icon(
                                  Icons.warning_amber_rounded,
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                                title: Text(
                                  state.error!,
                                  style: TextStyle(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ),
                          if (state.items.isEmpty)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No products yet',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap "Add product" to start building your catalog.',
                                      style: theme.textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...state.items.map(_buildInventoryCard),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(SellerInventoryItem item) {
    final theme = Theme.of(context);
    final product = item.product;
    final hasPending = product.syncStatus.isPending;
    final details = <String>[
      _formatPrice(product),
      'Disponible: ${item.quantityOnHand.toStringAsFixed(2)}',
      if (item.quantityReserved > 0)
        'Reservado: ${item.quantityReserved.toStringAsFixed(2)}',
      if (item.updatedAt != null)
        'Actualizado ${_formatTimestamp(item.updatedAt!)}',
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(details.join(' · ')),
        leading: CircleAvatar(
          backgroundColor: hasPending
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.primaryContainer,
          child: Icon(
            hasPending ? Icons.sync_outlined : Icons.inventory_2_outlined,
            color: hasPending
                ? theme.colorScheme.onSecondaryContainer
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _openEditor(context, product: product);
            } else if (value == 'delete') {
              _confirmDelete(product);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => _openEditor(context, product: product),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {Product? product}) async {
    final editorCubit = context.read<ProductEditorCubit>();
    editorCubit.setDraft(product);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: editorCubit,
        child: _ProductFormSheet(
          sellerId: widget.seller.id,
          initialProduct: product,
        ),
      ),
    );

    editorCubit.clearStatus();
  }

  Future<void> _confirmDelete(Product product) async {
    final editorCubit = context.read<ProductEditorCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove product'),
        content: Text(
          'Are you sure you want to remove Ã¢Â€Âœ${product.name}Ã¢Â€Â? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await editorCubit.delete(product.id);
    }
  }

  String _formatPrice(Product product) {
    final unit = product.price.toString().trim();
    final buffer = StringBuffer('USD ')
      ..write(product.price.toStringAsFixed(2));
    if (unit.isNotEmpty) {
      buffer
        ..write(' / ')
        ..write(unit);
    }
    return buffer.toString();
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
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

class _ProductFormSheet extends StatefulWidget {
  const _ProductFormSheet({required this.sellerId, this.initialProduct});

  final String sellerId;
  final Product? initialProduct;

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _unitController;
  late final TextEditingController _categoryController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;
  late bool _inStock;
  late bool _isTrending;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final product = widget.initialProduct;
    _nameController = TextEditingController(text: product?.name ?? '');
    _priceController = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '',
    );
    _unitController = TextEditingController(text: product?.unit ?? '');
    _categoryController = TextEditingController(text: product?.category ?? '');
    _quantityController = TextEditingController(
      text: product?.quantity != null ? product!.quantity.toString() : '',
    );
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _inStock = product?.inStock ?? true;
    _isTrending = product?.isTrending ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialProduct != null;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BlocConsumer<ProductEditorCubit, ProductEditorState>(
        listenWhen: (previous, current) =>
            previous.lastAction != current.lastAction ||
            previous.hasError != current.hasError,
        listener: (context, state) {
          if (state.lastAction == ProductEditorAction.saved &&
              !state.isSaving) {
            Navigator.of(context).maybePop();
          }
        },
        builder: (context, state) {
          final isSaving = state.isSaving;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'Edit product' : 'Add new product',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Enter a product name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.attach_money_outlined),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      hintText: 'e.g. each, lb, box',
                      prefixIcon: Icon(Icons.straighten),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity available',
                      prefixIcon: Icon(Icons.numbers_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed < 0) {
                        return 'Enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.edit_outlined),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    value: _inStock,
                    onChanged: (value) => setState(() {
                      _inStock = value;
                    }),
                    title: const Text('In stock'),
                    subtitle: const Text('Show as available to shoppers'),
                  ),
                  SwitchListTile.adaptive(
                    value: _isTrending,
                    onChanged: (value) => setState(() {
                      _isTrending = value;
                    }),
                    title: const Text('Mark as trending'),
                    subtitle: const Text('Highlight this product in the feed'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () => Navigator.of(context).maybePop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: isSaving ? null : () => _submit(context),
                          icon: isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(isSaving ? 'Saving...' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price = double.parse(_priceController.text.trim());
    final quantityText = _quantityController.text.trim();
    final quantity = quantityText.isEmpty ? null : int.parse(quantityText);
    final product =
        (widget.initialProduct ??
                Product(
                  id: '',
                  sellerId: widget.sellerId,
                  name: '',
                  price: 0,
                  description: null,
                  category: null,
                  unit: null,
                  quantity: null,
                  isTrending: false,
                  inStock: true,
                ))
            .copyWith(
              sellerId: widget.sellerId,
              name: _nameController.text.trim(),
              price: price,
              unit: _unitController.text.trim().isEmpty
                  ? null
                  : _unitController.text.trim(),
              category: _categoryController.text.trim().isEmpty
                  ? null
                  : _categoryController.text.trim(),
              quantity: quantity,
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              inStock: _inStock,
              isTrending: _isTrending,
              updatedAt: DateTime.now(),
            );

    context.read<ProductEditorCubit>().save(product);
  }
}
