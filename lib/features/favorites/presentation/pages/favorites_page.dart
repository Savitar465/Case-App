import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/favorite_kind.dart';
import '../bloc/favorites_cubit.dart';
import '../widgets/favorite_category_tile.dart';
import 'favorite_list_page.dart';

/// "Favoritos" tab: a 2×2 grid of saved businesses, services, products and
/// offers. Reads the app-wide [FavoritesCubit].
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const String routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          final total = state.entries.length;
          return RefreshIndicator(
            color: AppColors.purple,
            onRefresh: context.read<FavoritesCubit>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                const Row(
                  children: [
                    Text(
                      'Favoritos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.favorite, color: AppColors.purple, size: 28),
                  ],
                ),
                const SizedBox(height: 20),
                if (state.isLoading && !state.hasLoaded)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: LinearProgressIndicator(color: AppColors.purple),
                  ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.78,
                  children: [
                    for (final kind in FavoriteKind.values)
                      FavoriteCategoryTile(
                        kind: kind,
                        count: state.countOf(kind),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => FavoriteListPage(kind: kind),
                          ),
                        ),
                      ),
                  ],
                ),
                if (state.hasLoaded && total == 0) ...[
                  const SizedBox(height: 20),
                  const _EmptyBanner(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyBanner extends StatelessWidget {
  const _EmptyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.purpleSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.palette.border,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite, color: AppColors.purple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aún no tienes favoritos',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'Empieza guardando lo que más te gusta y aparecerá aquí.',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.bookmark_rounded, color: AppColors.purple, size: 36),
        ],
      ),
    );
  }
}
