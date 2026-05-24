import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/full_screen_image_viewer.dart';
import '../../../items/domain/repositories/item_repository.dart';
import '../../../items/presentation/bloc/item_list_cubit.dart';
import '../../../items/presentation/widgets/business_items_section.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_image.dart';
import '../../domain/entities/business_schedule.dart';
import '../../domain/entities/business_status.dart';
import '../../domain/repositories/business_repository.dart';

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
  late Business _business;

  @override
  void initState() {
    super.initState();
    _business = widget.business;
    _itemListCubit = ItemListCubit(
      repository: context.read<ItemRepository>(),
      businessId: widget.business.id,
    )..initialize();
  }

  @override
  void dispose() {
    _itemListCubit.close();
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.share_outlined)),
          IconButton(onPressed: null, icon: Icon(Icons.favorite_border)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _BusinessCard(
            business: _business,
            imagesKey: _imagesKey,
            itemListCubit: _itemListCubit,
          ),
        ),
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({
    required this.business,
    required this.imagesKey,
    required this.itemListCubit,
  });

  final Business business;
  final GlobalKey<_BusinessImagesState> imagesKey;
  final ItemListCubit itemListCubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BusinessImages(key: imagesKey, businessId: business.id),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  business.name.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _IconLine(
            icon: Icons.location_on,
            iconColor: Colors.redAccent,
            text: business.address,
          ),
          const SizedBox(height: 4),
          _ScheduleLine(business: business),
          if (business.phone != null || business.whatsapp != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (business.phone != null)
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: null,
                      child: const Text('Recibir ofertas'),
                    ),
                  ),
                if (business.phone != null && business.whatsapp != null)
                  const SizedBox(width: 12),
                if (business.whatsapp != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                      ),
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          BusinessItemsSection(businessId: business.id, cubit: itemListCubit),
        ],
      ),
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
  late Future<List<BusinessImage>> _future;
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('Loading images for business_id=${widget.businessId}');
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
          return const _ImagePlaceholder(child: CircularProgressIndicator());
        }
        final images = snapshot.data ?? const <BusinessImage>[];
        if (images.isEmpty) {
          return const _ImagePlaceholder(
            child: Icon(Icons.storefront, size: 64),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
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
                        errorBuilder: (_, error, __) {
                          debugPrint('Image load failed: $url\nError: $error');
                          return _ImagePlaceholder(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Failed: $url\n$error',
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                if (images.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: _PageDots(
                      count: images.length,
                      currentIndex: _currentPage,
                    ),
                  ),
              ],
            ),
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
  const _ImagePlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: theme.colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: child,
        ),
      ),
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
                    text: '  $detail',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
