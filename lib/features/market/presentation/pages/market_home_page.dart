import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';
import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/repositories/market_repository.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';
import 'package:market_app/features/market/presentation/widgets/business_cards.dart';
import 'package:market_app/features/market/presentation/widgets/category_strip.dart';
import 'package:market_app/features/market/presentation/widgets/filter_chips_row.dart';
import 'package:market_app/features/market/presentation/widgets/home_bottom_nav.dart';
import 'package:market_app/features/market/presentation/widgets/home_header.dart';
import 'package:market_app/features/market/presentation/widgets/offers_carousel.dart';
import 'package:market_app/features/profile/presentation/pages/profile_page.dart';

class MarketHomePage extends StatefulWidget {
  const MarketHomePage({super.key});

  static const String routeName = '/market-home';

  @override
  State<MarketHomePage> createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      MarketCubit(
        repository: context.read<MarketRepository>(),
        businessRepository: context.read<BusinessRepository>(),
      )
        ..initialize(),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            _HomeView(),
            Center(child: Text('Ofertas (Próximamente)')),
            Center(child: Text('Favoritos (Próximamente)')),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: HomeBottomNav(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  /// How many businesses appear above the "Negocios destacados" row.
  static const int _nearbyCount = 3;

  @override
  void initState() {
    super.initState();
    _locate(userInitiated: false);
  }

  /// Best-effort: feeds the user's position (for distances) and region name
  /// (for the header) into the cubit. Silent unless the user asked for it.
  Future<void> _locate({required bool userInitiated}) async {
    final cubit = context.read<MarketCubit>();
    final messenger = ScaffoldMessenger.of(context);
    void explain(String message) {
      if (userInitiated) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
    }

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        explain('Activa la ubicación del dispositivo para ver distancias.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        explain('Necesitamos permiso de ubicación para ver distancias.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
      String? label;
      try {
        final places = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (places.isNotEmpty) {
          final place = places.first;
          label = [place.administrativeArea, place.locality]
              .whereType<String>()
              .map((s) => s.replaceFirst('Departamento de ', '').trim())
              .firstWhere((s) => s.isNotEmpty, orElse: () => '');
          if (label.isEmpty) label = null;
        }
      } catch (error) {
        // Reverse geocoding is cosmetic; keep the default label.
        debugPrint('Home reverse geocoding failed: $error');
      }
      if (cubit.isClosed) return;
      cubit.setUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        label: label,
      );
    } catch (error) {
      debugPrint('Home location lookup failed: $error');
      explain('No pudimos obtener tu ubicación.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarketCubit, MarketState>(
      listenWhen: (prev, curr) =>
      curr.error != null && prev.error != curr.error,
      listener: (context, state) =>
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!))),
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.purple,
          onRefresh: () => context.read<MarketCubit>().refresh(),
          child: BlocBuilder<MarketCubit, MarketState>(
            builder: (context, state) {
              final visible = state.visibleBusinesses;
              final featured = state.featuredBusinesses;
              final withOffers = state.businessIdsWithOffers;
              final cubit = context.read<MarketCubit>();

              Widget nearbyCard(Business business) =>
                  NearbyBusinessCard(
                    business: business,
                    distanceMeters: state.distanceTo(business),
                    isFavorite: state.favoriteIds.contains(business.id),
                    hasOffer: withOffers.contains(business.id),
                    onFavorite: () => cubit.toggleFavorite(business.id),
                  );

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeHeader(
                      onLocationTap: () => _locate(userInitiated: true),
                    ),
                  ),
                  const SliverToBoxAdapter(child: HomeSearchField()),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  const SliverToBoxAdapter(child: CategoryStrip()),
                  if (state.offers.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: HomeSectionTitle(
                        title: 'Ofertas cerca de ti',
                        icon: Icons.local_fire_department,
                        iconColor: AppColors.flame,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: OffersCarousel(offers: state.offers),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: FilterChipsRow(
                      onDistanceUnavailable: () => _locate(userInitiated: true),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: HomeSectionTitle(
                      title: 'Negocios cerca de ti',
                      icon: Icons.location_on,
                      iconColor: AppColors.offerRed,
                    ),
                  ),
                  if (state.isLoading && state.businesses.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                    )
                  else
                    if (visible.isEmpty)
                      SliverToBoxAdapter(
                        child: _EmptyResults(
                          hasFilters:
                          state.hasActiveFilters ||
                              state.searchQuery.isNotEmpty,
                          onClear: state.hasActiveFilters
                              ? cubit.clearFilters
                              : null,
                        ),
                      )
                    else
                      ...[
                        SliverList.list(
                          children: [
                            for (final business in visible.take(_nearbyCount))
                              nearbyCard(business),
                          ],
                        ),
                        if (featured.isNotEmpty) ...[
                          const SliverToBoxAdapter(
                            child: HomeSectionTitle(
                              title: 'Negocios destacados',
                              trailing: _ProBadge(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 198,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.fromLTRB(
                                    16, 0, 16, 8),
                                itemCount: featured.length,
                                separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                                itemBuilder: (context, index) =>
                                    FeaturedBusinessCard(
                                      business: featured[index],
                                      distanceMeters: state.distanceTo(
                                        featured[index],
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 16)),
                        ],
                        SliverList.list(
                          children: [
                            for (final business in visible.skip(_nearbyCount))
                              nearbyCard(business),
                          ],
                        ),
                      ],
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.offerRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.hasFilters, required this.onClear});

  final bool hasFilters;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.storefront, size: 48, color: AppColors.purple),
          const SizedBox(height: 12),
          Text(
            hasFilters
                ? 'No encontramos negocios con esos filtros.'
                : 'Aún no hay negocios registrados.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              child: const Text(
                'Limpiar filtros',
                style: TextStyle(color: AppColors.purple),
              ),
            ),
        ],
      ),
    );
  }
}
