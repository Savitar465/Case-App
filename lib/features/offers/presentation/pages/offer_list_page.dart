import 'package:flutter/material.dart';

import '../widgets/business_offers_section.dart';

class OfferListPage extends StatelessWidget {
  const OfferListPage({super.key, required this.businessId});

  static const String routeName = '/offers';

  final String businessId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ofertas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BusinessOffersSection(businessId: businessId),
      ),
    );
  }
}
