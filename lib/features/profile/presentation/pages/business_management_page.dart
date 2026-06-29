import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/profile_business.dart';
import '../widgets/profile_widgets.dart';

/// Owner-facing dashboard for a single business (design `img_2.png`).
///
/// The header, "Tu rendimiento" views/followers and status reflect real data
/// from the selected business. Catalog management actions navigate to their
/// dedicated flows (wired as they are built).
class BusinessManagementPage extends StatelessWidget {
  const BusinessManagementPage({super.key, required this.business});

  final ProfileBusiness business;

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text('$feature estará disponible pronto')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          _Header(
            business: business,
            onEdit: () => _comingSoon(context, 'Editar información'),
          ),
          const SizedBox(height: 18),
          BoostPromo(onActivate: () => _comingSoon(context, 'Impulsar negocio')),
          const SizedBox(height: 24),
          const _SectionTitle('Tu rendimiento'),
          const SizedBox(height: 12),
          _Performance(business: business),
          const SizedBox(height: 24),
          const _SectionTitle('Acciones rápidas'),
          const SizedBox(height: 12),
          _QuickActions(
            onCreateOffer: () => _comingSoon(context, 'Crear oferta'),
            onAddProduct: () => _comingSoon(context, 'Agregar producto'),
            onAddService: () => _comingSoon(context, 'Agregar servicio'),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Administrar negocio'),
          const SizedBox(height: 12),
          _ManageList(onTap: (label) => _comingSoon(context, label)),
        ],
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
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
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.black54,
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
      const _Stat(
        icon: Icons.local_fire_department,
        color: Colors.deepOrange,
        value: '—',
        label: 'Ofertas activas',
      ),
      const _Stat(
        icon: Icons.star,
        color: AppColors.star,
        value: '—',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE7F6)),
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
            style: const TextStyle(fontSize: 12, color: Colors.black54),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDE7F6)),
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

  static const List<_ManageEntry> _entries = [
    _ManageEntry(Icons.local_fire_department, 'Ofertas activas'),
    _ManageEntry(Icons.inventory_2_outlined, 'Productos'),
    _ManageEntry(Icons.room_service_outlined, 'Servicios'),
    _ManageEntry(Icons.photo_library_outlined, 'Fotos del negocio'),
    _ManageEntry(Icons.access_time, 'Horario'),
    _ManageEntry(Icons.public, 'Redes sociales y página web'),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEDE7F6)),
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
                  const Icon(Icons.chevron_right, color: Colors.black38),
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
