import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/offer_detail.dart';
import '../../domain/repositories/offer_repository.dart';
import '../../domain/usecases/get_followed_business_ids_use_case.dart';
import '../../domain/usecases/refresh_active_offers_use_case.dart';
import '../../domain/usecases/watch_active_offers_use_case.dart';
import '../bloc/offers_feed_cubit.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail_sheet.dart';
import '../widgets/offers_filter_bar.dart';
import 'offers_section_page.dart';

/// "Ofertas" tab: offers ending soon, from followed businesses, and all.
class OffersPage extends StatelessWidget {
  const OffersPage({
    super.key,
    this.isActive = true,
    this.userLatitude,
    this.userLongitude,
  });

  static const routeName = '/offers/feed';

  /// Whether the tab is visible; follows are re-read when it becomes active.
  final bool isActive;
  final double? userLatitude;
  final double? userLongitude;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<OfferRepository>();
    return BlocProvider(
      create: (_) => OffersFeedCubit(
        watchActiveOffers: WatchActiveOffersUseCase(repository),
        refreshActiveOffers: RefreshActiveOffersUseCase(repository),
        getFollowedBusinessIds: GetFollowedBusinessIdsUseCase(repository),
      )..initialize(),
      child: _OffersView(
        isActive: isActive,
        userLatitude: userLatitude,
        userLongitude: userLongitude,
      ),
    );
  }
}

class _OffersView extends StatefulWidget {
  const _OffersView({
    required this.isActive,
    required this.userLatitude,
    required this.userLongitude,
  });

  final bool isActive;
  final double? userLatitude;
  final double? userLongitude;

  @override
  State<_OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<_OffersView> {
  /// Countdowns show minutes, so a 30 s tick keeps them accurate enough.
  static const _tick = Duration(seconds: 30);

  Timer? _timer;
  DateTime _now = DateTime.now();
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant _OffersView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      _syncTimer();
      if (widget.isActive) {
        context.read<OffersFeedCubit>().refreshFollowed();
      }
    }
  }

  /// Only tick while the tab is on screen.
  void _syncTimer() {
    _timer?.cancel();
    if (!widget.isActive) return;
    // Callers rebuild right after (initState / didUpdateWidget).
    _now = DateTime.now();
    _timer = Timer.periodic(_tick, (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  double? _distanceTo(OfferDetail offer) {
    final lat = widget.userLatitude;
    final lng = widget.userLongitude;
    if (lat == null || lng == null) return null;
    return offer.distanceMetersTo(lat, lng);
  }

  void _toggleSearch() {
    setState(() => _searching = !_searching);
    if (!_searching) {
      _searchController.clear();
      context.read<OffersFeedCubit>().setQuery('');
    }
  }

  void _openSection(_SectionSpec spec) {
    final cubit = context.read<OffersFeedCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: OffersSectionPage.routeName),
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: OffersSectionPage(
            section: spec.section,
            title: spec.title,
            distanceTo: _distanceTo,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.palette.page,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(searching: _searching, onSearch: _toggleSearch),
            if (_searching)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: context.read<OffersFeedCubit>().setQuery,
                  decoration: InputDecoration(
                    hintText: 'Buscar ofertas o negocios',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: context.palette.surface,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: context.palette.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: context.palette.border),
                    ),
                  ),
                ),
              ),
            Divider(height: 1, color: context.palette.border),
            const SizedBox(height: 10),
            const OffersFilterBar(),
            const SizedBox(height: 4),
            Expanded(
              child: BlocBuilder<OffersFeedCubit, OffersFeedState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OffersFeedState state) {
    final cubit = context.read<OffersFeedCubit>();
    if (state.isLoading && state.offers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.offers.isEmpty) {
      return _EmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'No se pudieron cargar las ofertas',
        message: state.error!,
        actionLabel: 'Reintentar',
        onAction: cubit.refresh,
      );
    }

    final sections = [
      for (final spec in _SectionSpec.all)
        (spec: spec, offers: state.section(spec.section, _now)),
    ].where((s) => s.offers.isNotEmpty).toList();

    return RefreshIndicator(
      color: AppColors.purple,
      onRefresh: cubit.refresh,
      child: sections.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 60),
                state.hasFilters || state.query.isNotEmpty
                    ? _EmptyState(
                        icon: Icons.filter_alt_off_outlined,
                        title: 'Sin resultados',
                        message:
                            'Ninguna oferta coincide con tu búsqueda o '
                            'filtros.',
                        actionLabel: 'Limpiar filtros',
                        onAction: () {
                          _searchController.clear();
                          cubit
                            ..setQuery('')
                            ..clearFilters();
                        },
                      )
                    : const _EmptyState(
                        icon: Icons.local_offer_outlined,
                        title: 'No hay ofertas activas',
                        message:
                            'Vuelve más tarde: los negocios publican '
                            'promociones todos los días.',
                      ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final entry = sections[index];
                return _OffersSection(
                  spec: entry.spec,
                  offers: entry.offers,
                  now: _now,
                  distanceTo: _distanceTo,
                  onSeeAll: () => _openSection(entry.spec),
                );
              },
            ),
    );
  }
}

/// Copy and icon of each carousel.
class _SectionSpec {
  const _SectionSpec({
    required this.section,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final OffersSection section;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  static const all = [
    _SectionSpec(
      section: OffersSection.endingSoon,
      title: 'Terminan pronto',
      subtitle: 'No dejes pasar estas ofertas, se acaban pronto.',
      icon: Icons.local_fire_department,
      iconColor: AppColors.flame,
    ),
    _SectionSpec(
      section: OffersSection.followed,
      title: 'De los negocios que sigues',
      subtitle: 'Tus negocios favoritos también tienen ofertas.',
      icon: Icons.favorite_border,
      iconColor: AppColors.purple,
    ),
    _SectionSpec(
      section: OffersSection.all,
      title: 'Todas las ofertas',
      subtitle: 'Explora todas las promociones disponibles.',
      icon: Icons.stars_rounded,
      iconColor: AppColors.purple,
    ),
  ];
}

class _Header extends StatelessWidget {
  const _Header({required this.searching, required this.onSearch});

  final bool searching;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Transform.rotate(
            angle: -0.2,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB873FF), Color(0xFF7B2FF7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.local_offer, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ofertas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  'Promociones que puedes aprovechar antes de que terminen.',
                  style: TextStyle(fontSize: 13, color: palette.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: palette.mutedFill,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: searching ? 'Cerrar búsqueda' : 'Buscar',
              icon: Icon(
                searching ? Icons.close : Icons.search,
                color: palette.textPrimary,
              ),
              onPressed: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _OffersSection extends StatelessWidget {
  const _OffersSection({
    required this.spec,
    required this.offers,
    required this.now,
    required this.distanceTo,
    required this.onSeeAll,
  });

  /// Cards shown in the carousel before "Ver todas".
  static const _maxCards = 10;

  final _SectionSpec spec;
  final List<OfferDetail> offers;
  final DateTime now;
  final double? Function(OfferDetail) distanceTo;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final shown = offers.take(_maxCards).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(spec.icon, color: spec.iconColor, size: 26),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: palette.textPrimary,
                        ),
                      ),
                      Text(
                        spec.subtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ver todas'),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: OfferCard.height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: shown.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final offer = shown[index];
                return SizedBox(
                  width: OfferCard.width,
                  child: OfferCard(
                    offer: offer,
                    now: now,
                    distanceMeters: distanceTo(offer),
                    onTap: () => showOfferDetailSheet(context, offer),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: palette.faint),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.textSecondary),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purple,
                side: const BorderSide(color: AppColors.purple),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
