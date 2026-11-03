import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../business_register/domain/entities/business_registration_failure.dart';
import '../../../business_register/domain/entities/catalog_item_draft.dart';
import '../../../business_register/domain/repositories/business_registration_repository.dart';
import '../../../business_register/domain/usecases/delete_business_use_case.dart';
import '../../../business_register/presentation/pages/catalog_list_page.dart';
import '../../../business_register/presentation/pages/edit_business_page.dart';
import '../../../business_register/presentation/pages/manage_offers_page.dart';
import '../../domain/entities/profile_business.dart';
import '../../domain/repositories/profile_repository.dart';
import '../widgets/profile_widgets.dart';

/// Owner-facing dashboard for a single business (design `img_2.png`).
///
/// The header, "Tu rendimiento" views/followers and status reflect real data
/// from the selected business. Every action opens its own flow: one edit
/// screen per business section, product/service lists and the offer list.
///
/// Pops `true` when the business was edited or deleted so the caller can
/// reload its list.
class BusinessManagementPage extends StatefulWidget {
  const BusinessManagementPage({super.key, required this.business});

  final ProfileBusiness business;

  @override
  State<BusinessManagementPage> createState() => _BusinessManagementPageState();
}

class _BusinessManagementPageState extends State<BusinessManagementPage> {
  late ProfileBusiness _business = widget.business;
  bool _changed = false;
  bool _deleting = false;

  /// Opens a catalog screen; on return the stats (active offers) and cover
  /// may have changed, so the header is refreshed.
  Future<void> _openCatalog(Widget page, String routeName) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (_) => page,
      ),
    );
    if (!mounted) return;
    _changed = true;
    await _refreshHeader();
  }

  void _openItems(CatalogItemKind kind, {bool add = false}) => _openCatalog(
    CatalogListPage(businessId: _business.id, kind: kind, openAddOnStart: add),
    CatalogListPage.routeName,
  );

  void _openOffers({bool create = false}) => _openCatalog(
    ManageOffersPage(businessId: _business.id, openCreateOnStart: create),
    ManageOffersPage.routeName,
  );

  Future<void> _openEdit([
    EditBusinessSection section = EditBusinessSection.info,
  ]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        settings: const RouteSettings(name: EditBusinessPage.routeName),
        builder: (_) =>
            EditBusinessPage(businessId: _business.id, section: section),
      ),
    );
    if (saved != true || !mounted) return;
    _changed = true;
    await _refreshHeader();
  }

  /// Re-reads the owned business so the header shows the edited name/address.
  Future<void> _refreshHeader() async {
    try {
      final overview = await context.read<ProfileRepository>().loadOverview();
      final updated = overview.owned.where((b) => b.id == _business.id);
      if (mounted && updated.isNotEmpty) {
        setState(() => _business = updated.first);
      }
    } catch (_) {
      // The edit is already saved; a stale header is harmless and the
      // profile list reloads when this page closes.
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar negocio?'),
        content: Text(
          '"${_business.name}" dejará de aparecer en la app junto con sus '
          'productos, servicios y ofertas. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) await _delete();
  }

  Future<void> _delete() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final deleteBusiness = DeleteBusinessUseCase(
      context.read<BusinessRegistrationRepository>(),
    );
    setState(() => _deleting = true);
    try {
      await deleteBusiness(_business.id);
      messenger
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('Negocio eliminado')));
      navigator.pop(true);
    } catch (error) {
      debugPrint('deleteBusiness failed: $error');
      if (!mounted) return;
      setState(() => _deleting = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error is BusinessRegistrationFailure
                  ? error.message
                  : 'No se pudo eliminar el negocio',
            ),
          ),
        );
    }
  }

  void _onManage(String label) {
    switch (label) {
      case _ManageList.offers:
        _openOffers();
      case _ManageList.products:
        _openItems(CatalogItemKind.product);
      case _ManageList.services:
        _openItems(CatalogItemKind.service);
      case _ManageList.photos:
        _openEdit(EditBusinessSection.photos);
      case _ManageList.schedule:
        _openEdit(EditBusinessSection.schedule);
      case _ManageList.social:
        _openEdit(EditBusinessSection.social);
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = _business;
    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_deleting) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        backgroundColor: context.palette.page,
        appBar: AppBar(
          backgroundColor: context.palette.page,
          elevation: 0,
          foregroundColor: context.palette.textPrimary,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            _Header(business: business, onEdit: _openEdit),
            const SizedBox(height: 18),
            BoostPromo(
              onActivate: () => Navigator.of(
                context,
              ).pushNamed('/boost-business', arguments: business.id),
            ),
            const SizedBox(height: 24),
            const _SectionTitle('Tu rendimiento'),
            const SizedBox(height: 12),
            _Performance(business: business),
            const SizedBox(height: 24),
            const _SectionTitle('Acciones rápidas'),
            const SizedBox(height: 12),
            _QuickActions(
              onCreateOffer: () => _openOffers(create: true),
              onAddProduct: () =>
                  _openItems(CatalogItemKind.product, add: true),
              onAddService: () =>
                  _openItems(CatalogItemKind.service, add: true),
            ),
            const SizedBox(height: 24),
            const _SectionTitle('Administrar negocio'),
            const SizedBox(height: 12),
            _ManageList(onTap: _onManage),
            const SizedBox(height: 14),
            _DeleteButton(isLoading: _deleting, onPressed: _confirmDelete),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.redAccent,
              ),
            )
          : const Icon(Icons.delete_outline),
      label: const Text(
        'Eliminar negocio',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.business, required this.onEdit});

  final ProfileBusiness business;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessThumbnail(
          imageUrl: business.imageUrl,
          width: 96,
          height: 96,
          borderRadius: 16,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              StatusDot(isActive: business.isActive),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 15,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      business.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onEdit,
                child: const Row(
                  children: [
                    Icon(Icons.edit, size: 14, color: AppColors.purple),
                    SizedBox(width: 4),
                    Text(
                      'Editar información',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Performance extends StatelessWidget {
  const _Performance({required this.business});

  final ProfileBusiness business;

  @override
  Widget build(BuildContext context) {
    final stats = <_Stat>[
      _Stat(
        icon: Icons.visibility_outlined,
        color: AppColors.purple,
        value: _formatCount(business.viewsCount),
        label: 'Vistas',
      ),
      _Stat(
        icon: Icons.favorite,
        color: Colors.redAccent,
        value: _formatCount(business.followersCount),
        label: 'Favoritos',
      ),
      _Stat(
        icon: Icons.local_fire_department,
        color: Colors.deepOrange,
        value: _formatCount(business.activeOffersCount),
        label: 'Ofertas activas',
      ),
      _Stat(
        icon: Icons.star,
        color: AppColors.star,
        value: business.rating == null
            ? '—'
            : '${business.rating!.toStringAsFixed(1)} '
                  '(${business.reviewsCount})',
        label: 'Calificación',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: stats.map((s) => _StatCard(stat: s)).toList(),
    );
  }

  static String _formatCount(int value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)} mil';
    }
    return '$value';
  }
}

class _Stat {
  const _Stat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(stat.icon, color: stat.color, size: 22),
          const SizedBox(height: 6),
          Text(
            stat.value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: TextStyle(
              fontSize: 12,
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onCreateOffer,
    required this.onAddProduct,
    required this.onAddService,
  });

  final VoidCallback onCreateOffer;
  final VoidCallback onAddProduct;
  final VoidCallback onAddService;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.local_offer_outlined,
            label: 'Crear oferta',
            onTap: onCreateOffer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.inventory_2_outlined,
            label: 'Agregar producto',
            onTap: onAddProduct,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.room_service_outlined,
            label: 'Agregar servicio',
            onTap: onAddService,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.palette.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.purple, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageList extends StatelessWidget {
  const _ManageList({required this.onTap});

  final ValueChanged<String> onTap;

  static const String offers = 'Ofertas activas';
  static const String products = 'Productos';
  static const String services = 'Servicios';
  static const String photos = 'Fotos del negocio';
  static const String schedule = 'Horario';
  static const String social = 'Redes sociales y página web';

  static const List<_ManageEntry> _entries = [
    _ManageEntry(Icons.local_fire_department, offers),
    _ManageEntry(Icons.inventory_2_outlined, products),
    _ManageEntry(Icons.room_service_outlined, services),
    _ManageEntry(Icons.photo_library_outlined, photos),
    _ManageEntry(Icons.access_time, schedule),
    _ManageEntry(Icons.public, social),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in _entries) ...[
          InkWell(
            onTap: () => onTap(entry.label),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.palette.border),
              ),
              child: Row(
                children: [
                  Icon(entry.icon, color: AppColors.purple, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      entry.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: context.palette.textMuted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ManageEntry {
  const _ManageEntry(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}
