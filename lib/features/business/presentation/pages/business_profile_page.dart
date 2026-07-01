import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/contact_launcher.dart';
import '../../../../core/widgets/full_screen_image_viewer.dart';
import '../../../../core/widgets/static_location_map.dart';
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
      backgroundColor: Colors.white,
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
                  onPressed: () =>
                      ContactLauncher.openWhatsApp(context, whatsapp),
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
  });

  final Business business;
  final ItemListCubit itemListCubit;
  final OfferListCubit offerListCubit;

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
      decoration: const BoxDecoration(
        color: Colors.white,
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
          const _RatingSummary(),
          const SizedBox(height: 10),
          _IconLine(
            icon: Icons.location_on,
            iconColor: Colors.redAccent,
            text: business.address,
          ),
          if (business.latitude != 0 || business.longitude != 0) ...[
            const SizedBox(height: 12),
            StaticLocationMap(
              latitude: business.latitude,
              longitude: business.longitude,
            ),
          ],
          const SizedBox(height: 6),
          _ScheduleLine(business: business),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '"$description"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _ActionButtons(business: business),
          const SizedBox(height: 22),
          _OffersBlock(
            cubit: offerListCubit,
            onSeeAll: () => _openOffers(context),
          ),
          _SectionLabel(
            icon: Icons.touch_app_outlined,
            text: 'Selecciona lo que te interesa para consultar',
          ),
          const SizedBox(height: 12),
          BusinessItemsSection(
            businessId: business.id,
            cubit: itemListCubit,
            onSeeAll: () => _openItems(context),
          ),
          const SizedBox(height: 24),
          const _ReviewsSection(),
          const SizedBox(height: 24),
          Center(child: _SocialRow(business: business)),
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
  const _RatingSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ReviewListCubit, ReviewListState>(
      buildWhen: (a, b) => a.stats != b.stats,
      builder: (context, state) {
        final stats = state.stats;
        if (!stats.hasReviews) {
          return Row(
            children: [
              const _Stars(rating: 0),
              const SizedBox(width: 6),
              Text(
                'Sin opiniones aún',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black45,
                ),
              ),
            ],
          );
        }
        return Row(
          children: [
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
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
            ),
          ],
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
  const _ActionButtons({required this.business});

  final Business business;

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
            onPressed: () => ContactLauncher.openWhatsApp(context, whatsapp),
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

/// "Opiniones" header + review list, backed by the `reviews` table.
class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection();

  Future<void> _writeReview(BuildContext context) async {
    final cubit = context.read<ReviewListCubit>();
    final existing = cubit.state.myReview;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
    return BlocBuilder<ReviewListCubit, ReviewListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Opiniones',
              actionLabel: state.myReview != null ? 'Editar' : 'Escribir',
              onSeeAll: () => _writeReview(context),
            ),
            const SizedBox(height: 12),
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (!state.hasReviews)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Aún no hay opiniones. ¡Sé el primero en opinar!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              )
            else
              Column(
                children: [
                  for (final review in state.reviews.take(3))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ReviewCard(review: review),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.leadingIcon,
    this.onSeeAll,
    this.actionLabel = 'Ver todas',
  });

  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onSeeAll;
  final String actionLabel;

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel,
                    style: const TextStyle(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.purple,
                    size: 20,
                  ),
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
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFECECEC)),
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
                        color: Colors.black45,
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
                color: Colors.black87,
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

/// Social links pulled from `businesses.social_networks` (+ website), opened
/// with the system browser/app.
class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.business});

  final Business business;

  static const Map<String, IconData> _icons = {
    'facebook': Icons.facebook,
    'instagram': Icons.camera_alt_outlined,
    'tiktok': Icons.music_note,
    'twitter': Icons.alternate_email,
    'x': Icons.alternate_email,
    'youtube': Icons.smart_display_outlined,
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
        final icon = _icons[lower];
        if (icon == null) return;
        entries.add(
          _SocialEntry(
            icon: icon,
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
          onTap: () => ContactLauncher.openWebsite(context, website),
        ),
      );
    }
    if (entries.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in entries)
          IconButton(
            onPressed: entry.onTap,
            icon: Icon(entry.icon, color: Colors.black87, size: 26),
          ),
      ],
    );
  }
}

class _SocialEntry {
  const _SocialEntry({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;
}

class _WhatsappFab extends StatelessWidget {
  const _WhatsappFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.whatsapp,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      icon: const Icon(Icons.chat),
      label: const Text('Consultar por WhatsApp'),
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
          return const _ImagePlaceholder(
            height: _height,
            child: Icon(Icons.storefront, size: 64, color: Colors.black38),
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
                      errorBuilder: (_, _, _) => const _ImagePlaceholder(
                        height: _height,
                        child: Icon(
                          Icons.storefront,
                          size: 64,
                          color: Colors.black38,
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
      color: const Color(0xFFE6E6E6),
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
    if (schedule != null && schedule.isNotEmpty) {
      final status = BusinessSchedule.fromMap(
        schedule,
      ).statusAt(DateTime.now());
      isOpen = status.isOpen;
      detail = status.detail;
    } else {
      isOpen = business.status == BusinessStatus.active;
    }

    final color = isOpen ? Colors.green : Colors.redAccent;
    return Row(
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
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}
