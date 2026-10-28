import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/offer_detail.dart';
import '../bloc/offers_feed_cubit.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail_sheet.dart';

/// "Ver todas": one section of the "Ofertas" tab as a two-column grid.
/// Expects the tab's [OffersFeedCubit] above it, so filters carry over.
class OffersSectionPage extends StatefulWidget {
  const OffersSectionPage({
    super.key,
    required this.section,
    required this.title,
    required this.distanceTo,
  });

  static const routeName = '/offers/section';

  final OffersSection section;
  final String title;
  final double? Function(OfferDetail) distanceTo;

  @override
  State<OffersSectionPage> createState() => _OffersSectionPageState();
}

class _OffersSectionPageState extends State<OffersSectionPage> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.page,
      appBar: AppBar(
        backgroundColor: palette.page,
        surfaceTintColor: palette.page,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocBuilder<OffersFeedCubit, OffersFeedState>(
        builder: (context, state) {
          final offers = state.section(widget.section, _now);
          if (offers.isEmpty) {
            return Center(
              child: Text(
                'No hay ofertas en esta sección',
                style: TextStyle(color: palette.textSecondary),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: OfferCard.height,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return OfferCard(
                offer: offer,
                now: _now,
                distanceMeters: widget.distanceTo(offer),
                onTap: () => showOfferDetailSheet(context, offer),
              );
            },
          );
        },
      ),
    );
  }
}
