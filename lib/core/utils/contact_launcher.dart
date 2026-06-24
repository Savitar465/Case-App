import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thin wrapper around `url_launcher` for the contact / social actions on the
/// business profile. Each method shows a SnackBar when the link can't open.
abstract final class ContactLauncher {
  static Future<void> openWhatsApp(
    BuildContext context,
    String number, {
    String? message,
  }) {
    final digits = _digitsOnly(number);
    final text = message == null ? '' : '?text=${Uri.encodeComponent(message)}';
    return _open(context, 'https://wa.me/$digits$text');
  }

  static Future<void> call(BuildContext context, String number) {
    return _open(context, 'tel:${_digitsOnly(number, keepPlus: true)}');
  }

  static Future<void> openWebsite(BuildContext context, String url) {
    final normalized = url.startsWith('http') ? url : 'https://$url';
    return _open(context, normalized);
  }

  /// Opens a social-network entry. Bare handles/usernames are expanded into the
  /// network's profile URL.
  static Future<void> openSocial(
    BuildContext context,
    String network,
    String value,
  ) {
    final trimmed = value.trim();
    if (trimmed.startsWith('http')) return _open(context, trimmed);
    final handle = trimmed.replaceFirst('@', '');
    final url = switch (network.toLowerCase()) {
      'facebook' => 'https://facebook.com/$handle',
      'instagram' => 'https://instagram.com/$handle',
      'tiktok' => 'https://tiktok.com/@$handle',
      'twitter' || 'x' => 'https://x.com/$handle',
      _ => 'https://$handle',
    };
    return _open(context, url);
  }

  static Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    final ok =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  static String _digitsOnly(String value, {bool keepPlus = false}) {
    final pattern = keepPlus ? RegExp(r'[^0-9+]') : RegExp(r'[^0-9]');
    return value.replaceAll(pattern, '');
  }
}
