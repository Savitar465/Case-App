import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/settings_widgets.dart';
import 'appearance_page.dart';
import 'change_password_page.dart';
import 'contact_support_page.dart';
import 'notification_settings_page.dart';

/// "Configuración" hub opened from the profile menu.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.isGuest,
    required this.onOpenBusinesses,
  });

  static const routeName = '/settings';

  final bool isGuest;

  /// "Mis negocios" lives in the profile feature; the caller decides where it
  /// goes so this page doesn't depend on it.
  final VoidCallback onOpenBusinesses;

  void _push(BuildContext context, String name, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: name),
        builder: (_) => page,
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    showSettingsSnackBar(context, '$feature estará disponible pronto');
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const LogoutRequested());
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Configuración',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const SettingsSectionTitle('Cuenta'),
          SettingsGroup(
            children: [
              if (!isGuest) ...[
                SettingsTile(
                  icon: Icons.lock_outline,
                  label: 'Cambiar contraseña',
                  onTap: () => _push(
                    context,
                    ChangePasswordPage.routeName,
                    const ChangePasswordPage(),
                  ),
                ),
                SettingsTile(
                  icon: Icons.notifications_none,
                  label: 'Notificaciones',
                  onTap: () => _push(
                    context,
                    NotificationSettingsPage.routeName,
                    const NotificationSettingsPage(),
                  ),
                ),
              ],
              SettingsTile(
                icon: Icons.palette_outlined,
                label: 'Apariencia',
                onTap: () => _push(
                  context,
                  AppearancePage.routeName,
                  const AppearancePage(),
                ),
              ),
            ],
          ),
          if (!isGuest) ...[
            const SizedBox(height: 22),
            const SettingsSectionTitle('Gestión'),
            SettingsGroup(
              children: [
                SettingsTile(
                  icon: Icons.storefront_outlined,
                  label: 'Mis negocios',
                  onTap: onOpenBusinesses,
                ),
                SettingsTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'Pagos y facturación',
                  onTap: () => _comingSoon(context, 'Pagos y facturación'),
                ),
              ],
            ),
          ],
          const SizedBox(height: 22),
          const SettingsSectionTitle('Privacidad y seguridad'),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.shield_outlined,
                label: 'Términos y condiciones',
                onTap: () => _comingSoon(context, 'Términos y condiciones'),
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                label: 'Política de privacidad',
                onTap: () => _comingSoon(context, 'La política de privacidad'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SettingsSectionTitle('Ayuda'),
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.help_outline,
                label: 'Centro de ayuda',
                onTap: () => _comingSoon(context, 'El centro de ayuda'),
              ),
              if (!isGuest)
                SettingsTile(
                  icon: Icons.chat_bubble_outline,
                  label: 'Contactar soporte',
                  onTap: () => _push(
                    context,
                    ContactSupportPage.routeName,
                    const ContactSupportPage(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),
          SettingsGroup(
            children: [
              if (isGuest)
                SettingsTile(
                  icon: Icons.login,
                  label: 'Iniciar sesión',
                  showChevron: false,
                  onTap: () =>
                      Navigator.of(context).pushNamed(LoginPage.routeName),
                )
              else
                SettingsTile(
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  color: Colors.redAccent,
                  showChevron: false,
                  onTap: () => _logout(context),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
