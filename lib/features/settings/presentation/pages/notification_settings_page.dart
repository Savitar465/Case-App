import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../../domain/usecases/update_notification_preferences_use_case.dart';
import '../bloc/notification_settings_cubit.dart';
import '../widgets/settings_widgets.dart';

const _green = Color(0xFF2E7D32);

/// Lighter green for icons on dark surfaces, where #2E7D32 is too dim.
Color _iconGreen(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF66BB6A)
    : _green;

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  static const routeName = '/settings/notifications';

  @override
  Widget build(BuildContext context) {
    final repository = context.read<SettingsRepository>();
    return BlocProvider(
      create: (_) => NotificationSettingsCubit(
        loadSettings: LoadAccountSettingsUseCase(repository),
        updatePreferences: UpdateNotificationPreferencesUseCase(repository),
      )..load(),
      child: const _NotificationSettingsView(),
    );
  }
}

class _NotificationSettingsView extends StatelessWidget {
  const _NotificationSettingsView();

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Notificaciones',
      body: BlocConsumer<NotificationSettingsCubit, NotificationSettingsState>(
        listenWhen: (prev, curr) =>
            !curr.isLoading && curr.error != null && curr.error != prev.error,
        listener: (context, state) =>
            showSettingsSnackBar(context, state.error!),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final prefs = state.preferences;
          final cubit = context.read<NotificationSettingsCubit>();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              SettingsGroup(
                children: [
                  _SwitchRow(
                    icon: Icons.notifications_active_outlined,
                    title: 'Activar todas las notificaciones',
                    subtitle: 'Recibe todas las alertas de la app.',
                    value: prefs.allEnabled,
                    onChanged: cubit.setAll,
                  ),
                ],
              ),
              const _GroupLabel('OFERTAS DE NEGOCIOS QUE SIGUES'),
              SettingsGroup(
                children: [
                  _SwitchRow(
                    icon: Icons.local_offer_outlined,
                    title: 'Nuevas ofertas',
                    subtitle:
                        'Te avisamos cuando un negocio que sigues publique '
                        'una oferta.',
                    value: prefs.newOffers,
                    onChanged: cubit.setNewOffers,
                  ),
                  _SwitchRow(
                    icon: Icons.timer_outlined,
                    title: 'Ofertas por vencer',
                    subtitle:
                        'Recuerda las ofertas que guardaste antes de que '
                        'terminen.',
                    value: prefs.expiringOffers,
                    onChanged: cubit.setExpiringOffers,
                  ),
                ],
              ),
              const _GroupLabel('GENERAL'),
              SettingsGroup(
                children: [
                  _SwitchRow(
                    icon: Icons.campaign_outlined,
                    title: 'Mensajes importantes de la app',
                    subtitle:
                        'Avisos sobre tu cuenta, seguridad y novedades de '
                        'la app.',
                    value: prefs.appMessages,
                    onChanged: cubit.setAppMessages,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SettingsInfoCard(
                icon: Icons.verified_user,
                title: 'Tú tienes el control',
                message: 'Puedes cambiar estas preferencias cuando quieras.',
                color: _iconGreen(context),
                background: _green.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.18
                      : 0.09,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: context.palette.textPrimary,
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: _green,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: Icon(icon, color: _iconGreen(context)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
      ),
    );
  }
}
