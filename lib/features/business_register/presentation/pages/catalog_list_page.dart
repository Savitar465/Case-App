import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../bloc/catalog_cubit.dart';
import '../widgets/catalog_widgets.dart';
import '../widgets/flash_offer_fields.dart';
import 'catalog_item_form_page.dart';

/// Owner list of a business's products or services ("Productos" /
/// "Servicios" on the dashboard): add, edit, pause/activate and delete.
class CatalogListPage extends StatelessWidget {
  const CatalogListPage({
    super.key,
    required this.businessId,
    required this.kind,
    this.openAddOnStart = false,
  });

  static const routeName = '/business/catalog';

  final String businessId;
  final CatalogItemKind kind;

  /// Opens the add form right away (dashboard "Agregar producto/servicio").
  final bool openAddOnStart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogCubit(
        repository: context.read<CatalogRepository>(),
        businessId: businessId,
      )..load(),
      child: _CatalogListView(kind: kind, openAddOnStart: openAddOnStart),
    );
  }
}

class _CatalogListView extends StatefulWidget {
  const _CatalogListView({required this.kind, required this.openAddOnStart});

  final CatalogItemKind kind;
  final bool openAddOnStart;

  @override
  State<_CatalogListView> createState() => _CatalogListViewState();
}

class _CatalogListViewState extends State<_CatalogListView> {
  CatalogItemKind get _kind => widget.kind;

  String get _plural =>
      _kind == CatalogItemKind.service ? 'Servicios' : 'Productos';

  @override
  void initState() {
    super.initState();
    if (widget.openAddOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _add());
    }
  }

  Future<void> _add() async {
    final cubit = context.read<CatalogCubit>();
    final draft = await Navigator.of(context).push<CatalogItemDraft>(
      MaterialPageRoute(builder: (_) => CatalogItemFormPage(kind: _kind)),
    );
    if (draft != null) await cubit.addItem(draft);
  }

  Future<void> _edit(CatalogItem item) async {
    final cubit = context.read<CatalogCubit>();
    final draft = await Navigator.of(context).push<CatalogItemDraft>(
      MaterialPageRoute(
        builder: (_) => CatalogItemFormPage(kind: _kind, initial: item),
      ),
    );
    if (draft != null) await cubit.updateItem(item, draft);
  }

  Future<void> _delete(CatalogItem item) async {
    final cubit = context.read<CatalogCubit>();
    final confirmed = await confirmDestructive(
      context,
      title: '¿Eliminar ${_kind.singular}?',
      message:
          '"${item.name}" y sus ofertas se eliminarán para siempre. Si solo '
          'quieres ocultarlo por un tiempo, usa "Pausar".',
    );
    if (confirmed) await cubit.deleteItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.page,
      appBar: AppBar(
        backgroundColor: context.palette.page,
        surfaceTintColor: context.palette.page,
        foregroundColor: context.palette.textPrimary,
        centerTitle: true,
        title: Text(
          _plural,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Agregar ${_kind.singular}'),
      ),
      body: BlocConsumer<CatalogCubit, CatalogState>(
        listenWhen: catalogFeedbackChanged,
        listener: showCatalogFeedback,
        builder: (context, state) {
          if (!state.hasLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = state.itemsOf(_kind);
          return RefreshIndicator(
            onRefresh: context.read<CatalogCubit>().load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
              children: [
                if (items.isEmpty)
                  CatalogEmptyState(
                    icon: _kind == CatalogItemKind.service
                        ? Icons.room_service_outlined
                        : Icons.inventory_2_outlined,
                    message:
                        'Aún no tienes ${_plural.toLowerCase()}. Agrega el '
                        'primero para que tus clientes lo vean.',
                  ),
                for (final item in items) ...[
                  _ItemTile(
                    item: item,
                    isBusy: state.busyIds.contains(item.id),
                    onEdit: () => _edit(item),
                    onToggle: () => context.read<CatalogCubit>().setItemActive(
                      item,
                      isActive: !item.isActive,
                    ),
                    onDelete: () => _delete(item),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.isBusy,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final CatalogItem item;
  final bool isBusy;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final stock = item.stock;
    return CatalogTile(
      imageUrl: item.photoUrl,
      fallbackIcon: item.kind == CatalogItemKind.service
          ? Icons.room_service_outlined
          : Icons.inventory_2_outlined,
      title: item.name,
      subtitle:
          'Bs ${formatAmount(item.price)} · '
          '${stock == null ? 'Sin límite' : 'Disponibles: $stock'}',
      dimmed: !item.isActive,
      badge: item.isActive
          ? null
          : const StatusChip(label: 'Pausado', color: Colors.grey),
      isBusy: isBusy,
      onTap: onEdit,
      actions: [
        CatalogAction('Editar', Icons.edit_outlined, onEdit),
        CatalogAction(
          item.isActive ? 'Pausar' : 'Activar',
          item.isActive
              ? Icons.pause_circle_outline
              : Icons.play_circle_outline,
          onToggle,
        ),
        CatalogAction(
          'Eliminar',
          Icons.delete_outline,
          onDelete,
          destructive: true,
        ),
      ],
    );
  }
}
