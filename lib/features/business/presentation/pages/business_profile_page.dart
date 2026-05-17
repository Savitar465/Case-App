import 'package:flutter/material.dart';

import '../../domain/entities/business.dart';
import '../../domain/entities/business_status.dart';

class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({super.key, required this.business});

  static const String routeName = '/business-profile';

  final Business business;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: _BusinessCard(business: business),
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.storefront, size: 64),
              ),
            ),
          ),
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
          _IconLine(
            icon: Icons.access_time,
            iconColor: Colors.green,
            text: business.status == BusinessStatus.active ? 'Open' : 'Closed',
          ),
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
        ],
      ),
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
