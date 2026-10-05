import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../market/presentation/widgets/business_cards.dart';
import '../../domain/entities/favorite_entry.dart';
import '../../domain/entities/favorite_kind.dart';
import '../bloc/favorites_cubit.dart';
import '../widgets/favorite_button.dart';
import '../widgets/favorite_category_tile.dart';

/// Saved entries of one [kind]. Tapping a row opens the owning business.
class FavoriteListPage extends StatelessWidget {
  const FavoriteListPage({super.key, required this.kind});

  final FavoriteKind kind;

  @override
  Widget build(BuildContext context) {
    final entries = context.select(
      (FavoritesCubit c) => c.state.entriesOf(kind),
    );
    return Scaffold(
      backgroundColor: context.palette.pageTinted,
      appBar: AppBar(
        backgroundColor: context.palette.pageTinted,
        surfaceTintColor: Colors.transparent,
        title: Text(
          kind.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.purple,
        onRefresh: context.read<FavoritesCubit>().refresh,
        child: entries.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: [
                  const SizedBox(height: 40),
                  FavoriteIllustration(kind: kind, scale: 1.2),
                  const SizedBox(height: 24),
                  Text(
                    kind.emptyMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.palette.textSecondary),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _FavoriteRow(entry: entries[index]),
              ),
      ),
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  const _FavoriteRow({required this.entry});

  final FavoriteEntry entry;

  String? get _price {
    final price = entry.price;
    if (price == null) return null;
    final amount = price.toStringAsFixed(price % 1 == 0 ? 0 : 2);
    return entry.currency == 'USD' ? '\$$amount' : 'Bs. $amount';
  }

  @override
  Widget build(BuildContext context) {
    final price = _price;
    return Material(
      color: context.palette.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openBusinessProfile(context, entry.businessId),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: entry.imageUrl == null
                      ? const _Placeholder()
                      : Image.network(
                          entry.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const _Placeholder(),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (entry.subtitle?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(
                        entry.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ],
                    if (price != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              FavoriteButton(
                kind: entry.kind,
                targetId: entry.targetId,
                size: 22,
                onSurface: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.palette.purpleSurface,
      child: Icon(Icons.image_outlined, color: AppColors.purple),
    );
  }
}
