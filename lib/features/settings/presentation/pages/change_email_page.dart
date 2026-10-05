import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/request_email_change_use_case.dart';
import '../../domain/usecases/watch_email_changes_use_case.dart';
import '../bloc/change_email_cubit.dart';
import '../widgets/settings_widgets.dart';
import 'email_verification_sent_page.dart';

/// "Correo electrónico": asks for the new address and sends the
/// verification link.
class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({super.key, required this.currentEmail});

  static const routeName = '/settings/email';

  final String currentEmail;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<SettingsRepository>();
    return BlocProvider(
      create: (_) => ChangeEmailCubit(
        currentEmail: currentEmail,
        requestEmailChange: RequestEmailChangeUseCase(repository),
        watchEmailChanges: WatchEmailChangesUseCase(repository),
      ),
      child: const _ChangeEmailView(),
    );
  }
}

class _ChangeEmailView extends StatefulWidget {
  const _ChangeEmailView();

  @override
  State<_ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<_ChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentController;
  final _newController = TextEditingController();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    _currentController = TextEditingController(
      text: context.read<ChangeEmailCubit>().state.currentEmail,
    );
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangeEmailCubit>().submit(_newController.text);
  }

  void _openSentPage(BuildContext context) {
    final cubit = context.read<ChangeEmailCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(
          name: EmailVerificationSentPage.routeName,
        ),
        // Shares the cubit so the next page hears the confirmation.
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const EmailVerificationSentPage(),
        ),
      ),
    );
  }

  String? _validate(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa tu nuevo correo';
    if (!_emailPattern.hasMatch(email)) return 'Ingresa un correo válido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Correo electrónico',
      body: BlocListener<ChangeEmailCubit, ChangeEmailState>(
        listener: (context, state) {
          if (state.error != null) {
            showSettingsSnackBar(context, state.error!);
          }
        },
        listenWhen: (prev, curr) =>
            curr.error != null && curr.error != prev.error,
        child: BlocListener<ChangeEmailCubit, ChangeEmailState>(
          listenWhen: (prev, curr) =>
              curr.pendingEmail != null &&
              curr.pendingEmail != prev.pendingEmail,
          listener: (context, _) => _openSentPage(context),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                SettingsTextField(
                  label: 'Correo electrónico actual',
                  controller: _currentController,
                  readOnly: true,
                ),
                const SizedBox(height: 18),
                SettingsTextField(
                  label: 'Nuevo correo electrónico',
                  hintText: 'tucorreo@ejemplo.com',
                  controller: _newController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: _validate,
                ),
                const SizedBox(height: 22),
                const SettingsInfoCard(
                  icon: Icons.info_outline,
                  message:
                      'Te enviaremos un enlace de verificación a tu nuevo '
                      'correo para confirmar el cambio.',
                ),
                const SizedBox(height: 28),
                BlocSelector<ChangeEmailCubit, ChangeEmailState, bool>(
                  selector: (state) => state.isSubmitting,
                  builder: (context, isSubmitting) => SettingsPrimaryButton(
                    label: 'Guardar cambios',
                    icon: Icons.save_outlined,
                    isLoading: isSubmitting,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
