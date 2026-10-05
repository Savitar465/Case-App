import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/profile_business.dart';
import '../widgets/profile_widgets.dart';

/// Full list of the businesses the user owns ("Mis negocios").
class MyBusinessesPage extends StatelessWidget {
  const MyBusinessesPage({
    super.key,
    required this.businesses,
    required this.onOpen,
    required this.onCreate,
  });

  static const routeName = '/profile/my-businesses';

  final List<ProfileBusiness> businesses;
  final ValueChanged<ProfileBusiness> onOpen;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.page,
      appBar: AppBar(
        backgroundColor: context.palette.page,
        surfaceTintColor: context.palette.page,
        centerTitle: true,
        title: const Text(
          'Mis negocios',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            if (businesses.isEmpty)
              const EmptyHint(
                icon: Icons.storefront_outlined,
                message: 'Aún no has registrado ningún negocio.',
              ),
            for (final business in businesses) ...[
              OwnedBusinessRow(
                business: business,
                onTap: () => onOpen(business),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            CreateBusinessButton(onPressed: onCreate),
          ],
        ),
      ),
    );
  }
}
