import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_support_tickets_use_case.dart';
import '../bloc/help_center_cubit.dart';
import '../widgets/settings_widgets.dart';
import 'contact_support_page.dart';

/// "Centro de ayuda": displays the user's submitted support requests,
/// their current resolution status, and team responses.
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key, required this.isGuest});

  static const routeName = '/settings/help-center';

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    if (isGuest) {
      return const SettingsScaffold(
        title: 'Centro de ayuda',
        body: _GuestHelpCenterView(),
      );
    }

    return BlocProvider(
      create: (context) => HelpCenterCubit(
        getSupportTickets: GetSupportTicketsUseCase(
          context.read<SettingsRepository>(),
        ),
      )..loadTickets(),
      child: const SettingsScaffold(
        title: 'Centro de ayuda',
        body: _HelpCenterView(),
      ),
    );
  }
}

class _HelpCenterView extends StatelessWidget {
  const _HelpCenterView();

  Future<void> _openContactSupport(BuildContext context) async {
    final sent = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        settings: const RouteSettings(name: ContactSupportPage.routeName),
        builder: (_) => const ContactSupportPage(),
      ),
    );

    if (sent == true && context.mounted) {
      context.read<HelpCenterCubit>().loadTickets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpCenterCubit, HelpCenterState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<HelpCenterCubit>().loadTickets(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _HelpBanner(onContactTap: () => _openContactSupport(context)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SettingsSectionTitle('Mis solicitudes de contacto'),
                  if (state.tickets.isNotEmpty)
                    Text(
                      '${state.tickets.length}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.palette.textSecondary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (state.isLoading && state.tickets.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && state.tickets.isEmpty)
                _ErrorCard(
                  error: state.error!,
                  onRetry: () =>
                      context.read<HelpCenterCubit>().loadTickets(),
                )
              else if (state.tickets.isEmpty)
                _EmptyTicketsCard(
                  onContactTap: () => _openContactSupport(context),
                )
              else
                for (final ticket in state.tickets) ...[
                  _TicketCard(ticket: ticket),
                  const SizedBox(height: 14),
                ],
            ],
          ),
        );
      },
    );
  }
}

class _HelpBanner extends StatelessWidget {
  const _HelpBanner({required this.onContactTap});

  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.support_agent_outlined,
                  color: AppColors.purple,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Necesitas ayuda o tienes una duda?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Estamos aquí para asistirte con tu cuenta o tus compras.',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onContactTap,
              icon: const Icon(Icons.send_outlined, size: 18),
              label: const Text('Contactar soporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final SupportTicket ticket;

  String _formatDate(DateTime dt) {
    final months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[(dt.month - 1).clamp(0, 11)];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final hasResponse = ticket.hasResponse;

    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasResponse
              ? AppColors.purple.withValues(alpha: 0.35)
              : context.palette.border,
        ),
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.subject,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(ticket.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: ticket.status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.palette.page,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu mensaje:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: context.palette.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (hasResponse) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.purple.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.purple,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Respuesta de soporte:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ticket.response!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  if (ticket.updatedAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Actualizado: ${_formatDate(ticket.updatedAt!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.palette.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 15,
                  color: context.palette.textMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'En espera de respuesta del equipo de soporte.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: context.palette.textMuted,
                    ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status.toLowerCase()) {
      'resolved' || 'resuelto' => (
        'Resuelto',
        const Color(0xFFE8F5E9),
        const Color(0xFF2E7D32),
      ),
      'in_progress' || 'en_progreso' || 'en progreso' => (
        'En revisión',
        const Color(0xFFE3F2FD),
        const Color(0xFF1565C0),
      ),
      'closed' || 'cerrado' => (
        'Cerrado',
        const Color(0xFFF5F5F5),
        const Color(0xFF616161),
      ),
      _ => (
        'Pendiente',
        const Color(0xFFFFF8E1),
        const Color(0xFFE65100),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyTicketsCard extends StatelessWidget {
  const _EmptyTicketsCard({required this.onContactTap});

  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: context.palette.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'No tienes solicitudes activas',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cuando envíes una consulta al equipo de soporte, verás su estado y las respuestas aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onContactTap,
            icon: const Icon(Icons.chat_bubble_outline, size: 16),
            label: const Text('Enviar mensaje'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.purple,
              side: const BorderSide(color: AppColors.purple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 36, color: Colors.redAccent),
          const SizedBox(height: 10),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _GuestHelpCenterView extends StatelessWidget {
  const _GuestHelpCenterView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.palette.border),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.account_circle_outlined,
                size: 50,
                color: AppColors.purple,
              ),
              const SizedBox(height: 12),
              Text(
                'Inicia sesión para ver tus solicitudes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.palette.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Para consultar el historial de soporte y dar seguimiento a tus mensajes, debes ingresar con tu cuenta.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: context.palette.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginPage.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

