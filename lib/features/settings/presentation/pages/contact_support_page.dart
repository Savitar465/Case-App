import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/submit_support_ticket_use_case.dart';
import '../bloc/contact_support_cubit.dart';
import '../widgets/settings_widgets.dart';

/// "Contactar soporte": creates a row in `support_tickets`.
class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  static const routeName = '/settings/support';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactSupportCubit(
        submitTicket: SubmitSupportTicketUseCase(
          context.read<SettingsRepository>(),
        ),
      ),
      child: const _ContactSupportView(),
    );
  }
}

class _ContactSupportView extends StatefulWidget {
  const _ContactSupportView();

  @override
  State<_ContactSupportView> createState() => _ContactSupportViewState();
}

class _ContactSupportViewState extends State<_ContactSupportView> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ContactSupportCubit>().submit(
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Contactar soporte',
      body: BlocConsumer<ContactSupportCubit, ContactSupportState>(
        listenWhen: (prev, curr) =>
            (curr.sent && !prev.sent) ||
            (curr.error != null && curr.error != prev.error),
        listener: (context, state) {
          if (state.sent) {
            showSettingsSnackBar(
              context,
              'Recibimos tu mensaje. Te responderemos pronto.',
            );
            Navigator.of(context).pop();
          } else {
            showSettingsSnackBar(context, state.error!);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Text(
                  'Cuéntanos qué pasó y te responderemos lo antes posible.',
                  style: TextStyle(color: context.palette.textSecondary),
                ),
                const SizedBox(height: 20),
                SettingsTextField(
                  label: 'Asunto',
                  hintText: 'Ej. No puedo publicar una oferta',
                  controller: _subjectController,
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value?.trim() ?? '').isEmpty
                      ? 'Escribe un asunto'
                      : null,
                ),
                const SizedBox(height: 18),
                SettingsTextField(
                  label: 'Mensaje',
                  hintText: 'Describe tu problema o sugerencia',
                  controller: _messageController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  validator: (value) => (value?.trim().length ?? 0) < 10
                      ? 'Cuéntanos un poco más (mínimo 10 caracteres)'
                      : null,
                ),
                const SizedBox(height: 28),
                SettingsPrimaryButton(
                  label: 'Enviar mensaje',
                  icon: Icons.send_outlined,
                  isLoading: state.isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
