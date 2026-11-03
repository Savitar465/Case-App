import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/entities/catalog_offer.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../bloc/catalog_cubit.dart';
import '../widgets/catalog_widgets.dart';
import '../widgets/flash_offer_fields.dart';
import 'catalog_list_page.dart';
import 'flash_offer_form_page.dart';

/// Owner list of a business's flash offers ("Ofertas activas" on the
/// dashboard): create, edit, pause/activate and delete.
class ManageOffersPage extends StatelessWidget {
  const ManageOffersPage({
    super.key,
    required this.businessId,
    this.openCreateOnStart = false,
  });

  static const routeName = '/business/offers';

  final String businessId;

  /// Opens the create form once loaded (dashboard "Crear oferta").
  final bool openCreateOnStart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogCubit(
        repository: context.read<CatalogRepository>(),
        businessId: businessId,
      )..load(),
      child: _ManageOffersView(openCreateOnStart: openCreateOnStart),
    );
  }
}

class _ManageOffersView extends StatefulWidget {
  const _ManageOffersView({required this.openCreateOnStart});

  final bool openCreateOnStart;

  @override
  State<_ManageOffersView> createState() => _ManageOffersViewState();
}

class _ManageOffersViewState extends State<_ManageOffersView> {
  late bool _pendingCreate = widget.openCreateOnStart;

  Future<void> _create() async {
    final cubit = context.read<CatalogCubit>();
    final items = cubit.state.items.where((item) => item.isActive).toList();
    if (items.isEmpty) {
      await _askForItem();
      return;
    }
    final result = await Navigator.of(context).push<FlashOfferFormResult>(
      MaterialPageRoute(builder: (_) => FlashOfferFormPage(items: items)),
    );
    if (result != null) {
      await cubit.saveOffer(item: result.item, offer: result.offer);
    }
  }

  Future<void> _edit(CatalogOffer offer) async {
    final cubit = context.read<CatalogCubit>();
    final item = _itemOf(offer);
    if (item == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Esta oferta no está vinculada a un producto y no se puede '
              'editar. Puedes pausarla o eliminarla.',
            ),
          ),
        );
      return;
    }
    final result = await Navigator.of(context).push<FlashOfferFormResult>(
      MaterialPageRoute(
        builder: (_) => FlashOfferFormPage(
          items: [item],
          initialItem: item,
          initialOffer: offer.schedule,
        ),
      ),
    );
    if (result != null) {
      await cubit.saveOffer(
        item: result.item,
        offer: result.offer,
        offerId: offer.id,
      );
    }
  }

  Future<void> _delete(CatalogOffer offer) async {
    final cubit = context.read<CatalogCubit>();
    final confirmed = await confirmDestructive(
      context,
      title: '¿Eliminar oferta?',
      message:
          'La oferta de "${offer.itemName}" se eliminará para siempre. Si '
          'solo quieres detenerla por un tiempo, usa "Pausar".',
    );
    if (confirmed) await cubit.deleteOffer(offer);
  }

  /// Offers need an item: let the owner add one first, then come back.
  Future<void> _askForItem() async {
    final cubit = context.read<CatalogCubit>();
    final kind = await showModalBottomSheet<CatalogItemKind>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Primero agrega un producto o servicio',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Las ofertas flash se aplican a uno de tus productos o '
                'servicios activos.',
                style: TextStyle(color: sheetContext.palette.textSecondary),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.purple,
                ),
                title: const Text('Agregar producto'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(CatalogItemKind.product),
              ),
              ListTile(
                leading: const Icon(
                  Icons.room_service_outlined,
                  color: AppColors.purple,
                ),
                title: const Text('Agregar servicio'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(CatalogItemKind.service),
              ),
            ],
          ),
        ),
      ),
    );
    if (kind == null || !mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        settings: const RouteSettings(name: CatalogListPage.routeName),
        builder: (_) => CatalogListPage(
          businessId: cubit.state.businessId,
          kind: kind,
          openAddOnStart: true,
        ),
      ),
    );
    await cubit.load();
  }

  CatalogItem? _itemOf(CatalogOffer offer) {
    for (final item in context.read<CatalogCubit>().state.items) {
      if (item.id == offer.itemId) return item;
    }
    return null;
  }

  /// Active first, then scheduled, paused and expired.
  List<CatalogOffer> _sorted(List<CatalogOffer> offers, DateTime now) {
    const order = [
      CatalogOfferStatus.active,
      CatalogOfferStatus.scheduled,
      CatalogOfferStatus.paused,
      CatalogOfferStatus.expired,
    ];
    return [...offers]..sort(
      (a, b) => order
          .indexOf(a.statusAt(now))
          .compareTo(order.indexOf(b.statusAt(now))),
    );
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
        title: const Text(
          'Ofertas',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.bolt_rounded),
        label: const Text('Crear oferta'),
      ),
      body: BlocConsumer<CatalogCubit, CatalogState>(
        listenWhen: (previous, current) =>
            catalogFeedbackChanged(previous, current) ||
            (!previous.hasLoaded && current.hasLoaded),
        listener: (context, state) {
          showCatalogFeedback(context, state);
          // Opened from "Crear oferta": wait for items before the form.
          if (_pendingCreate && state.hasLoaded) {
            _pendingCreate = false;
            _create();
          }
        },
        builder: (context, state) {
          if (!state.hasLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final now = DateTime.now();
          final offers = _sorted(state.offers, now);
          return RefreshIndicator(
            onRefresh: context.read<CatalogCubit>().load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
              children: [
                if (offers.isEmpty)
                  const CatalogEmptyState(
                    icon: Icons.local_fire_department_outlined,
                    message:
                        'Aún no tienes ofertas. Crea una oferta flash para '
                        'atraer más clientes.',
                  ),
                for (final offer in offers) ...[
                  _OfferTile(
                    offer: offer,
                    status: offer.statusAt(now),
                    isBusy: state.busyIds.contains(offer.id),
                    onEdit: () => _edit(offer),
                    onToggle: () => context.read<CatalogCubit>().setOfferActive(
                      offer,
                      isActive: !offer.isActive,
                    ),
                    onDelete: () => _delete(offer),
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

class _OfferTile extends StatelessWidget {
  const _OfferTile({
    required this.offer,
    required this.status,
    required this.isBusy,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  final CatalogOffer offer;
  final CatalogOfferStatus status;
  final bool isBusy;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final schedule = offer.schedule;
    final (label, color) = switch (status) {
      CatalogOfferStatus.active => ('Activa', const Color(0xFF22C55E)),
      CatalogOfferStatus.scheduled => ('Programada', AppColors.purple),
      CatalogOfferStatus.paused => ('Pausada', Colors.grey),
      CatalogOfferStatus.expired => ('Vencida', Colors.redAccent),
    };
    return CatalogTile(
      imageUrl: offer.imageUrl,
      fallbackIcon: Icons.local_fire_department_outlined,
      title: offer.itemName,
      subtitle: offer.normalPrice > 0
          ? 'Bs ${formatAmount(offer.normalPrice)} → '
                'Bs ${formatAmount(offer.flashPrice)}'
          : 'Precio flash: Bs ${formatAmount(offer.flashPrice)}',
      detail:
          '${formatDate(schedule.startDate)} – ${formatDate(schedule.endDate)}'
          ' · ${formatTime(schedule.startTime)}–${formatTime(schedule.endTime)}',
      badge: StatusChip(label: label, color: color),
      dimmed:
          status == CatalogOfferStatus.paused ||
          status == CatalogOfferStatus.expired,
      isBusy: isBusy,
      onTap: onEdit,
      actions: [
        CatalogAction('Editar', Icons.edit_outlined, onEdit),
        CatalogAction(
          offer.isActive ? 'Pausar' : 'Activar',
          offer.isActive
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
