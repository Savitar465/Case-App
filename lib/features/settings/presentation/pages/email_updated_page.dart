import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../widgets/settings_widgets.dart';
import 'edit_profile_page.dart';

/// "Correo actualizado" confirmation.
class EmailUpdatedPage extends StatelessWidget {
  const EmailUpdatedPage({super.key});

  static const routeName = '/settings/email/updated';

  static const _successGreen = Color(0xFF1DB954);

  void _backToProfile(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) =>
          route.settings.name == EditProfilePage.routeName || route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Correo electrónico',
      showBack: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: _successGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              'Correo actualizado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              'Tu correo electrónico ha sido actualizado correctamente.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.palette.textTertiary),
            ),
            const Spacer(),
            SettingsPrimaryButton(
              label: 'Volver al perfil',
              onPressed: () => _backToProfile(context),
            ),
          ],
        ),
      ),
    );
  }
}
