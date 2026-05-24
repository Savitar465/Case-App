import 'package:flutter/material.dart';

import '../widgets/business_items_section.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key, required this.businessId});

  static const String routeName = '/items';

  final String businessId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos y servicios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BusinessItemsSection(businessId: businessId),
      ),
    );
  }
}
