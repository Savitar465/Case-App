import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/contact_launcher.dart';
import '../../../../core/widgets/full_screen_image_viewer.dart';
import '../../../items/domain/entities/item.dart';
import '../../../items/domain/entities/item_type.dart';
import '../../../items/domain/repositories/item_repository.dart';
import '../../../items/presentation/bloc/item_list_cubit.dart';
import '../../../items/presentation/pages/item_list_page.dart';
import '../../../items/presentation/widgets/business_items_section.dart';
import '../../../offers/domain/repositories/offer_repository.dart';
import '../../../offers/presentation/bloc/offer_list_cubit.dart';
import '../../../offers/presentation/pages/offer_list_page.dart';
import '../../../offers/presentation/widgets/business_offers_section.dart';
import '../../../reviews/domain/entities/review.dart';
import '../../../reviews/domain/repositories/review_repository.dart';
import '../../../reviews/presentation/bloc/review_list_cubit.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_image.dart';
import '../../domain/entities/business_schedule.dart';
import '../../domain/entities/business_status.dart';
import '../../domain/repositories/business_repository.dart';
import '../bloc/follow_cubit.dart';
import '../widgets/submit_review_sheet.dart';

/// Public business profile, styled after `design/perfil.svg` and wired to the
/// live Supabase backend (offers, items, reviews and follows).
class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key, required this.business});

  static const String routeName = '/business-profile';

  final Business business;

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  final GlobalKey<_BusinessImagesState> _imagesKey = GlobalKey();
  late final ItemListCubit _itemListCubit;
  late final OfferListCubit _offerListCubit;
  late final ReviewListCubit _reviewListCubit;
  late final FollowCubit _followCubit;
  late Business _business;
  final Map<String, Item> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _business = widget.business;
    _itemListCubit = ItemListCubit(
      repository: context.read<ItemRepository>(),
      businessId: widget.business.id,
    )..initialize();
    _offerListCubit = OfferListCubit(
      repository: context.read<OfferRepository>(),
      businessId: widget.business.id,
    )..initialize();
    _reviewListCubit = ReviewListCubit(
      repository: context.read<ReviewRepository>(),
      businessId: widget.business.id,
    )..initialize();
    _followCubit = FollowCubit(
      repository: context.read<BusinessRepository>(),
      businessId: widget.business.id,
      initialFollowersCount: widget.business.followersCount,
    )..initialize();
  }

  void _onSelectItem(Item item) {
    setState(() {
      if (_selectedItems.containsKey(item.id)) {
        _selectedItems.remove(item.id);
      } else {
        _selectedItems[item.id] = item;
      }
    });
  }

  void _clearSelectedItems() {
    setState(() {
      _selectedItems.clear();
    });
  }

  void _openWhatsApp() {
    final whatsapp = _business.whatsapp;
    if (whatsapp == null) return;
    final message = _buildWhatsAppMessage();
    ContactLauncher.openWhatsApp(context, whatsapp, message: message);
  }

  String _buildWhatsAppMessage() {
    if (_selectedItems.isEmpty) {
      return 'Hola ${_business.name}, quisiera hacer una consulta sobre sus servicios y productos.';
    }

    if (_selectedItems.length == 1) {
      final item = _selectedItems.values.first;
      final priceStr = formatItemPrice(item.currency, item.price);
      final kind = item.type == ItemType.service
          ? 'el servicio'
          : 'el producto';
      return 'Hola ${_business.name}, me interesa consultar sobre $kind "${item.name}" ($priceStr). ¿Tienen disponibilidad o más información?';
    }

    final buffer = StringBuffer();
    buffer.writeln(
      'Hola ${_business.name}, me interesa consultar sobre los siguientes productos/servicios:',
    );
    for (final item in _selectedItems.values) {
      final priceStr = formatItemPrice(item.currency, item.price);
      buffer.writeln('• ${item.name} ($priceStr)');
    }
    buffer.writeln('\n¿Tienen disponibilidad o más información?');
    return buffer.toString().trim();
  }

  @override
  void dispose() {
    _itemListCubit.close();
    _offerListCubit.close();
    _reviewListCubit.close();
    _followCubit.close();
    super.dispose();
  }

  Future<void> _refreshBusiness() async {
    final updated = await context.read<BusinessRepository>().getBusiness(
      _business.id,
    );
    if (updated != null && mounted) {
      setState(() => _business = updated);
    }
  }

  Future<void> _onRefresh() {
    return Future.wait([
      _refreshBusiness(),
      _imagesKey.currentState?.reload() ?? Future<void>.value(),
      _itemListCubit.refresh(),
      _offerListCubit.refresh(),
      _reviewListCubit.refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final whatsapp = _business.whatsapp;
    return Scaffold(
      backgroundColor: context.palette.page,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ReviewListCubit>.value(value: _reviewListCubit),
          BlocProvider<FollowCubit>.value(value: _followCubit),
        ],
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BusinessImages(key: _imagesKey, businessId: _business.id),
                    Transform.translate(
                      offset: const Offset(0, -24),
                      child: _ContentCard(
                        business: _business,
                        itemListCubit: _itemListCubit,
                        offerListCubit: _offerListCubit,
                        selectedItems: _selectedItems,
                        onSelectItem: _onSelectItem,
                        onClearSelected: _clearSelectedItems,
                        onContactWhatsApp: _openWhatsApp,
                      ),
                    ),
                    SizedBox(height: whatsapp != null ? 60 : 12),
                  ],
                ),
              ),
            ),
            const _TopControls(),
            if (whatsapp != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: _WhatsappFab(
                  onPressed: _openWhatsApp,
                  selectedCount: _selectedItems.length,
                  singleItemName: _selectedItems.length == 1
                      ? _selectedItems.values.first.name
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            _CircleIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).maybePop(),
            ),
            const Spacer(),
            const _CircleIconButton(icon: Icons.share_outlined),
            const SizedBox(width: 8),
            const _CircleIconButton(icon: Icons.favorite_border),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.business,
    required this.itemListCubit,
    required this.offerListCubit,
    this.selectedItems = const {},
    this.onSelectItem,
    this.onClearSelected,
    this.onContactWhatsApp,
  });

  final Business business;
  final ItemListCubit itemListCubit;
  final OfferListCubit offerListCubit;
  final Map<String, Item> selectedItems;
  final ValueChanged<Item>? onSelectItem;
  final VoidCallback? onClearSelected;
  final VoidCallback? onContactWhatsApp;

  void _openItems(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ItemListPage(businessId: business.id),
      ),
    );
  }

  void _openOffers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OfferListPage(businessId: business.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = business.description;
    return Container(
      decoration: BoxDecoration(
        color: context.palette.page,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            business.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          _RatingSummary(business: business),
          const SizedBox(height: 10),
          _LocationSection(business: business),
          const SizedBox(height: 6),
          _ScheduleLine(business: business),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '"$description"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: context.palette.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _ActionButtons(
            business: business,
            onContactWhatsApp: onContactWhatsApp,
          ),
          const SizedBox(height: 22),
          _OffersBlock(
            cubit: offerListCubit,
            onSeeAll: () => _openOffers(context),
          ),
          _SectionLabel(
            icon: Icons.touch_app_outlined,
            text: 'Selecciona lo que te interesa para consultar',
          ),
          if (selectedItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.purple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.purple,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedItems.length == 1
                              ? '1 elemento seleccionado'
                              : '${selectedItems.length} elementos seleccionados',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                      if (onClearSelected != null)
                        InkWell(
                          onTap: onClearSelected,
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              'Limpiar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.purple,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final item in selectedItems.values)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.palette.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.purple.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 160,
                                ),
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => onSelectItem?.call(item),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: AppColors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          BusinessItemsSection(
            businessId: business.id,
            cubit: itemListCubit,
            onSeeAll: () => _openItems(context),
            selectedItemIds: selectedItems.keys.toSet(),
            onItemTap: onSelectItem,
          ),
          const SizedBox(height: 20),
          _ReviewsButton(business: business),
          const SizedBox(height: 20),
          _SocialNetworksSection(business: business),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Renders the "Ofertas" header + carousel only when there is at least one
/// promotable offer, so the page never shows a lone header.
class _OffersBlock extends StatelessWidget {
  const _OffersBlock({required this.cubit, required this.onSeeAll});

  final OfferListCubit cubit;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferListCubit>.value(
      value: cubit,
      child: BlocBuilder<OfferListCubit, OfferListState>(
        builder: (context, state) {
          if (state.visibleOffers.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                leadingIcon: Icons.local_offer_outlined,
                title: 'Ofertas',
                onSeeAll: onSeeAll,
              ),
              const SizedBox(height: 12),
              OffersCarousel(offers: state.visibleOffers),
              const SizedBox(height: 22),
            ],
          );
        },
      ),
    );
  }
}

/// Real aggregate rating computed from the business's review rows.
class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReviewListCubit, ReviewListState>(
      buildWhen: (a, b) => a.stats != b.stats,
      builder: (context, state) {
        final stats = state.stats;
        return InkWell(
          onTap: () => _openReviewsDialog(context, business),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!stats.hasReviews) ...[
                  const _Stars(rating: 0),
                  const SizedBox(width: 6),
                  Text(
                    'Sin opiniones aún',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.palette.textTertiary,
                    ),
                  ),
                ] else ...[
                  _Stars(rating: stats.average),
                  const SizedBox(width: 6),
                  Text(
                    stats.average.toStringAsFixed(1),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${stats.count} ${stats.count == 1 ? 'opinión' : 'opiniones'})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.palette.textTertiary,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: context.palette.textTertiary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final IconData icon;
        if (rating >= i + 1) {
          icon = Icons.star;
        } else if (rating >= i + 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, color: AppColors.star, size: size);
      }),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.business, this.onContactWhatsApp});

  final Business business;
  final VoidCallback? onContactWhatsApp;

  @override
  Widget build(BuildContext context) {
    final whatsapp = business.whatsapp;
    final seguir = BlocConsumer<FollowCubit, FollowState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!)));
        context.read<FollowCubit>().acknowledgeError();
      },
      builder: (context, state) {
        final following = state.isFollowing;
        final onTap = state.isToggling
            ? null
            : () => context.read<FollowCubit>().toggle();
        if (following) {
          return FilledButton.icon(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.purple,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Siguiendo'),
          );
        }
        return OutlinedButton.icon(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.purple,
            side: const BorderSide(color: AppColors.purple),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Seguir'),
        );
      },
    );

    if (whatsapp == null) {
      return SizedBox(width: double.infinity, child: seguir);
    }
    return Row(
      children: [
        Expanded(child: seguir),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed:
                onContactWhatsApp ??
                () => ContactLauncher.openWhatsApp(context, whatsapp),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.whatsapp,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.chat, size: 18),
            label: const Text('WhatsApp'),
          ),
        ),
      ],
    );
  }
}

void _openReviewsDialog(BuildContext context, Business business) {
  final cubit = context.read<ReviewListCubit>();
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return BlocProvider<ReviewListCubit>.value(
        value: cubit,
        child: _ReviewsDialog(business: business),
      );
    },
  );
}

/// A dedicated button that displays the rating and review count,
/// and opens the full reviews dialog when tapped.
class _ReviewsButton extends StatelessWidget {
  const _ReviewsButton({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReviewListCubit, ReviewListState>(
      builder: (context, state) {
        final stats = state.stats;
        return Material(
          color: context.palette.purpleSurface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => _openReviewsDialog(context, business),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.palette.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.star.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: AppColors.star,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.hasReviews
                              ? 'Opiniones (${stats.count})'
                              : 'Opiniones',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stats.hasReviews
                              ? '${stats.average.toStringAsFixed(1)} de 5 estrellas · Toca para ver'
                              : 'Sin opiniones · Sé el primero en opinar',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.purple,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReviewsDialog extends StatelessWidget {
  const _ReviewsDialog({required this.business});

  final Business business;

  Future<void> _writeReview(BuildContext context) async {
    final cubit = context.read<ReviewListCubit>();
    final existing = cubit.state.myReview;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.page,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider<ReviewListCubit>.value(
        value: cubit,
        child: SubmitReviewSheet(
          initialRating: existing?.rating ?? 0,
          initialComment: existing?.comment ?? '',
          isEditing: existing != null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: context.palette.page,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.8,
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ReviewListCubit, ReviewListState>(
            builder: (context, state) {
              final stats = state.stats;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Opiniones (${stats.count})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Cerrar',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.palette.purpleSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: context.palette.border),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  stats.hasReviews
                                      ? stats.average.toStringAsFixed(1)
                                      : '0.0',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: context.palette.textPrimary,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                _Stars(rating: stats.average, size: 18),
                              ],
                            ),
                            Text(
                              stats.hasReviews
                                  ? '${stats.count} ${stats.count == 1 ? 'opinión de clientes' : 'opiniones de clientes'}'
                                  : 'Sin opiniones registradas',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () => _writeReview(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(
                            state.myReview != null
                                ? Icons.edit
                                : Icons.add_comment,
                            size: 16,
                          ),
                          label: Text(
                            state.myReview != null ? 'Editar' : 'Opinar',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Flexible(
                    child: state.isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : !state.hasReviews
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 48,
                                    color: context.palette.textTertiary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Aún no hay opiniones.\n¡Sé el primero en opinar!',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: context.palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.reviews.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return _ReviewCard(review: state.reviews[index]);
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.leadingIcon, this.onSeeAll});

  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: AppColors.purple, size: 20),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          InkWell(
            onTap: onSeeAll,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver todas',
                    style: TextStyle(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.purple, size: 20),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.purple, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.palette.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final comment = review.comment;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.purple,
                child: Text(
                  review.authorName.isNotEmpty
                      ? review.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _timeAgo(review.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              _Stars(rating: review.rating.toDouble(), size: 16),
            ],
          ),
          if (comment != null && comment.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              comment,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.palette.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date.toLocal());
    if (diff.inDays >= 1) {
      final d = diff.inDays;
      return 'hace $d ${d == 1 ? 'día' : 'días'}';
    }
    if (diff.inHours >= 1) {
      final h = diff.inHours;
      return 'hace $h ${h == 1 ? 'hora' : 'horas'}';
    }
    if (diff.inMinutes >= 1) {
      final m = diff.inMinutes;
      return 'hace $m ${m == 1 ? 'minuto' : 'minutos'}';
    }
    return 'hace un momento';
  }
}

/// Social links pulled from `businesses.social_networks` (+ website), placed
/// where opinions previously were.
class _SocialNetworksSection extends StatelessWidget {
  const _SocialNetworksSection({required this.business});

  final Business business;

  static const Map<String, (IconData, String, Color)> _networkMeta = {
    'facebook': (Icons.facebook, 'Facebook', Color(0xFF1877F2)),
    'instagram': (Icons.camera_alt_outlined, 'Instagram', Color(0xFFE4405F)),
    'tiktok': (Icons.music_note, 'TikTok', Color(0xFF000000)),
    'twitter': (Icons.alternate_email, 'X (Twitter)', Color(0xFF1DA1F2)),
    'x': (Icons.alternate_email, 'X', Color(0xFF1DA1F2)),
    'youtube': (Icons.smart_display_outlined, 'YouTube', Color(0xFFFF0000)),
  };

  @override
  Widget build(BuildContext context) {
    final entries = <_SocialEntry>[];
    final networks = business.socialNetworks;
    if (networks != null) {
      networks.forEach((key, value) {
        final str = value?.toString().trim() ?? '';
        if (str.isEmpty) return;
        final lower = key.toLowerCase();
        final meta = _networkMeta[lower];
        final icon = meta?.$1 ?? Icons.share;
        final label = meta?.$2 ?? key;
        final color = meta?.$3 ?? AppColors.purple;
        entries.add(
          _SocialEntry(
            icon: icon,
            label: label,
            handle: str,
            color: color,
            onTap: () => ContactLauncher.openSocial(context, lower, str),
          ),
        );
      });
    }
    final website = business.website;
    if (website != null && website.trim().isNotEmpty) {
      entries.add(
        _SocialEntry(
          icon: Icons.language,
          label: 'Sitio web',
          handle: website.trim(),
          color: AppColors.purple,
          onTap: () => ContactLauncher.openWebsite(context, website),
        ),
      );
    }

    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          leadingIcon: Icons.share_outlined,
          title: 'Redes sociales',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final entry in entries)
              Material(
                color: context.palette.purpleSurface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: entry.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.palette.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(entry.icon, color: entry.color, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          entry.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.open_in_new,
                          size: 13,
                          color: context.palette.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SocialEntry {
  const _SocialEntry({
    required this.icon,
    required this.label,
    required this.handle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String handle;
  final Color color;
  final VoidCallback onTap;
}

class _WhatsappFab extends StatelessWidget {
  const _WhatsappFab({
    required this.onPressed,
    this.selectedCount = 0,
    this.singleItemName,
  });

  final VoidCallback onPressed;
  final int selectedCount;
  final String? singleItemName;

  @override
  Widget build(BuildContext context) {
    final String label;
    if (selectedCount == 0) {
      label = 'Consultar por WhatsApp';
    } else if (selectedCount == 1) {
      label = 'Consultar sobre "$singleItemName"';
    } else {
      label = 'Consultar sobre $selectedCount productos';
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.whatsapp,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      icon: const Icon(Icons.chat),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _BusinessImages extends StatefulWidget {
  const _BusinessImages({super.key, required this.businessId});

  final String businessId;

  @override
  State<_BusinessImages> createState() => _BusinessImagesState();
}

class _BusinessImagesState extends State<_BusinessImages> {
  static const double _height = 280;

  late Future<List<BusinessImage>> _future;
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _future = context.read<BusinessRepository>().getBusinessImages(
      widget.businessId,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> reload() async {
    final future = context.read<BusinessRepository>().getBusinessImages(
      widget.businessId,
    );
    setState(() => _future = future);
    await future.catchError((_) => const <BusinessImage>[]);
  }

  void _openFullScreen(
    BuildContext context,
    List<BusinessImage> images,
    int initialIndex,
  ) {
    FullScreenImageViewer.open(
      context,
      imageUrls: images.map((image) => image.url).toList(),
      initialIndex: initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BusinessImage>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ImagePlaceholder(
            height: _height,
            child: CircularProgressIndicator(),
          );
        }
        final images = snapshot.data ?? const <BusinessImage>[];
        if (images.isEmpty) {
          return _ImagePlaceholder(
            height: _height,
            child: Icon(
              Icons.storefront,
              size: 64,
              color: context.palette.textMuted,
            ),
          );
        }
        return SizedBox(
          height: _height,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: images.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, index) {
                  final url = images[index].url;
                  return GestureDetector(
                    onTap: () => _openFullScreen(context, images, index),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          _ImagePlaceholder(
                            height: _height,
                            child: Icon(
                              Icons.storefront,
                              size: 64,
                              color: context.palette.textMuted,
                            ),
                          ),
                    ),
                  );
                },
              ),
              if (images.length > 1)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 40,
                  child: _PageDots(
                    count: images.length,
                    currentIndex: _currentPage,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white70,
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
          ),
        );
      }),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: context.palette.mutedFill,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _ScheduleLine extends StatelessWidget {
  const _ScheduleLine({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schedule = business.schedule;

    bool isOpen;
    String? detail;
    BusinessSchedule? weekly;
    if (schedule != null && schedule.isNotEmpty) {
      weekly = BusinessSchedule.fromMap(schedule);
      final status = weekly.statusAt(DateTime.now());
      isOpen = status.isOpen;
      detail = status.detail;
    } else {
      isOpen = business.status == BusinessStatus.active;
    }

    final color = isOpen ? Colors.green : Colors.redAccent;
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.access_time, color: color, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: isOpen ? 'Abierto' : 'Cerrado',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
                if (detail != null)
                  TextSpan(
                    text: '  ·  $detail',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (weekly != null)
          Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: context.palette.textSecondary,
          ),
      ],
    );

    if (weekly == null) return row;
    final week = weekly;
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => _WeeklyScheduleSheet(schedule: week),
      ),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: row,
      ),
    );
  }
}

class _WeeklyScheduleSheet extends StatelessWidget {
  const _WeeklyScheduleSheet({required this.schedule});

  final BusinessSchedule schedule;

  static const _dayNames = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sábado',
    7: 'Domingo',
  };

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().weekday;
    final palette = context.palette;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Horarios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (var day = 1; day <= 7; day++)
              _WeeklyScheduleRow(
                day: _dayNames[day]!,
                intervals: schedule.intervalsFor(day),
                isToday: day == today,
                mutedColor: palette.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyScheduleRow extends StatelessWidget {
  const _WeeklyScheduleRow({
    required this.day,
    required this.intervals,
    required this.isToday,
    required this.mutedColor,
  });

  final String day;
  final List<ScheduleInterval> intervals;
  final bool isToday;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final weight = isToday ? FontWeight.w700 : FontWeight.w500;
    final hours = intervals.isEmpty
        ? 'Cerrado'
        : intervals.map((i) => '${i.openLabel} - ${i.closeLabel}').join('\n');

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isToday ? context.palette.purpleSurface : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              isToday ? '$day (hoy)' : day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: weight,
                color: isToday ? AppColors.purple : null,
              ),
            ),
          ),
          Text(
            hours,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: weight,
              color: intervals.isEmpty ? Colors.redAccent : mutedColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSection extends StatefulWidget {
  const _LocationSection({required this.business});

  final Business business;

  @override
  State<_LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<_LocationSection> {
  Business get business => widget.business;

  /// "Calle 123" for the map link; falls back to the first address segment.
  late final Future<String> _streetLabel = _resolveStreetLabel();

  Future<String> _resolveStreetLabel() async {
    final fallback = business.address.split(',').first.trim();
    if (business.latitude == 0 && business.longitude == 0) return fallback;
    try {
      final placemarks = await placemarkFromCoordinates(
        business.latitude,
        business.longitude,
      );
      if (placemarks.isEmpty) return fallback;
      final p = placemarks.first;
      final street = (p.thoroughfare ?? '').trim();
      final number = (p.subThoroughfare ?? '').trim();
      if (street.isEmpty) return fallback;
      return number.isEmpty ? street : '$street $number';
    } catch (error) {
      debugPrint('Reverse geocoding failed: $error');
      return fallback;
    }
  }

  void _openMap(BuildContext context) {
    ContactLauncher.openGoogleMaps(
      context,
      latitude: business.latitude,
      longitude: business.longitude,
      address: business.address,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCoords = business.latitude != 0 || business.longitude != 0;
    final hasAddress = business.address.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (hasCoords || hasAddress) ? () => _openMap(context) : null,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  business.address,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        if (hasCoords || hasAddress) ...[
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _openMap(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.map_outlined,
                    size: 16,
                    color: AppColors.purple,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: FutureBuilder<String>(
                      future: _streetLabel,
                      builder: (context, snapshot) {
                        final street = snapshot.data ?? '';
                        return Text(
                          street.isEmpty ? 'Ver en Google Maps' : street,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.purple,
                            decoration: TextDecoration.underline,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.open_in_new,
                    size: 13,
                    color: AppColors.purple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
