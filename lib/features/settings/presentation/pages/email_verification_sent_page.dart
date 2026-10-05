import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../bloc/change_email_cubit.dart';
import '../widgets/settings_widgets.dart';
import 'edit_profile_page.dart';
import 'email_updated_page.dart';

/// "Enlace de verificación enviado". Expects a [ChangeEmailCubit] above it
/// and moves on to [EmailUpdatedPage] once the link is confirmed.
class EmailVerificationSentPage extends StatelessWidget {
  const EmailVerificationSentPage({super.key});

  static const routeName = '/settings/email/sent';

  /// Opens the provider's webmail (the app, if installed, claims the link);
  /// falls back to the default mail app.
  Future<void> _openMailbox(BuildContext context, String email) async {
    final domain = email.split('@').last.toLowerCase();
    final url = switch (domain) {
      'gmail.com' || 'googlemail.com' => 'https://mail.google.com/mail/',
      'outlook.com' ||
      'hotmail.com' ||
      'live.com' => 'https://outlook.live.com/mail/',
      'yahoo.com' || 'yahoo.es' => 'https://mail.yahoo.com/',
      _ => 'mailto:',
    };
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      showSettingsSnackBar(context, 'No se pudo abrir tu correo');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = context.select<ChangeEmailCubit, String>(
      (cubit) => cubit.state.pendingEmail ?? '',
    );
    return BlocListener<ChangeEmailCubit, ChangeEmailState>(
      listenWhen: (prev, curr) => curr.isUpdated && !prev.isUpdated,
      listener: (context, state) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: EmailUpdatedPage.routeName),
            builder: (_) => const EmailUpdatedPage(),
          ),
        );
      },
      child: SettingsScaffold(
        title: 'Correo electrónico',
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            const Icon(
              Icons.mark_email_read_outlined,
              size: 110,
              color: AppColors.purple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Enlace de verificación enviado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              'Te enviamos un enlace a',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.palette.textPrimary),
            ),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(
              'Revisa tu bandeja de entrada (y la carpeta de spam) y abre el '
              'enlace para verificar tu nuevo correo. Si también recibes un '
              'correo en tu dirección actual, confírmalo para completar el '
              'cambio.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.palette.textTertiary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            SettingsPrimaryButton(
              label: 'Ir a mi correo',
              onPressed: () => _openMailbox(context, email),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).popUntil(
                (route) =>
                    route.settings.name == EditProfilePage.routeName ||
                    route.isFirst,
              ),
              style: TextButton.styleFrom(foregroundColor: AppColors.purple),
              child: const Text(
                'Entendido, volver al perfil',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
