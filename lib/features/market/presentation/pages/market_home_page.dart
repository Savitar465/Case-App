import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/domain/repositories/market_repository.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';

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
          MarketCubit(repository: context.read<MarketRepository>())
            ..initialize(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            _HomeView(),
            Center(child: Text('Favoritos (Próximamente)')),
            Center(child: Text('Perfil (Próximamente)')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<MarketCubit>().refresh(),
        child: CustomScrollView(
          slivers: [
            // 1. Barra superior: Ubicación y Notificaciones
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ubicación actual',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Tu Ciudad, Calle 123',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Badge(
                        child: Icon(Icons.notifications_none_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 2. Buscador (Visual)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SearchBar(
                  hintText: 'Buscar negocios o productos...',
                  leading: const Icon(Icons.search, color: Colors.grey),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
                ),
              ),
            ),
            // 3. Categorías horizontales
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: BlocBuilder<MarketCubit, MarketState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) =>
                          _CategoryItem(category: state.categories[index]),
                    ),
                  );
                },
              ),
            ),
            // 4. Promociones (Cards horizontales)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Ofertas destacadas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 3,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: 280,
                      color: Colors.blue[50],
                      child: const Center(child: Text('Banner Promocional')),
                    ),
                  ),
                ),
              ),
            ),
            // 5. Lista de negocios vertical
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Negocios cercanos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            BlocBuilder<MarketCubit, MarketState>(
              builder: (context, state) {
                if (state.isLoading && state.businesses.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _BusinessTile(business: state.businesses[index]),
                      childCount: state.businesses.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});
  final MarketCategory category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            child: Icon(
              _getIconData(category.icon),
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(category.nameEs, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Convierte el string hexadecimal de Supabase a IconData de forma segura.
  /// Soporta formatos como "e8cc" o "0xe8cc".
  IconData _getIconData(String? iconHex) {
    if (iconHex == null || iconHex.isEmpty) return Icons.store_outlined;

    try {
      // Si el string viene con "0x", eliminamos los primeros dos caracteres
      final cleanHex = iconHex.startsWith('0x') ? iconHex.substring(2) : iconHex;

      // IMPORTANTE: No usar 'const' aquí ya que el valor se parsea en ejecución
      // ignore: non_const_argument_for_const_parameter
      return IconData(
        int.parse(cleanHex, radix: 16),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      // Si el formato es inválido (ej: "restaurant"), devolvemos icono por defecto
      return Icons.store_outlined;
    }
  }
}

class _BusinessTile extends StatelessWidget {
  const _BusinessTile({required this.business});
  final Business business;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.business)),
      title: Text(
        business.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        business.address,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}
