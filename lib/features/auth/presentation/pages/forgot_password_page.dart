import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/send_password_reset_email_use_case.dart';
import '../../domain/usecases/update_password_use_case.dart';
import '../bloc/password_reset_cubit.dart';
import '../widgets/auth_widgets.dart';

/// "¿Olvidaste tu contraseña?": asks for the email and sends the reset link.
/// Opening the link lands on `NewPasswordPage` (pushed from `main.dart`).
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key, this.initialEmail});

  static const routeName = '/forgot-password';

  final String? initialEmail;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<AuthRepository>();
    return BlocProvider(
      create: (_) => PasswordResetCubit(
        sendPasswordResetEmail: SendPasswordResetEmailUseCase(repository),
        updatePassword: UpdatePasswordUseCase(repository),
      ),
      child: _ForgotPasswordView(initialEmail: initialEmail),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView({this.initialEmail});

  final String? initialEmail;

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordResetCubit>().sendResetEmail(
      _emailController.text.trim(),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa tu email';
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!pattern.hasMatch(email)) return 'Email inválido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.page,
      appBar: AppBar(
        backgroundColor: context.palette.page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<PasswordResetCubit, PasswordResetState>(
        listenWhen: (prev, curr) =>
            curr.error != null && curr.error != prev.error,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        },
        builder: (context, state) {
          final sentTo = state.sentToEmail;
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                if (sentTo == null)
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthResetHeader(
                          icon: Icons.lock_reset,
                          title: '¿Olvidaste tu contraseña?',
                          subtitle:
                              'Ingresa el correo de tu cuenta y te enviaremos '
                              'un enlace para crear una nueva contraseña.',
                        ),
                        const SizedBox(height: 28),
                        AuthTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 24),
                        AuthPrimaryButton(
                          label: 'Enviar enlace',
                          isLoading: state.isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  )
                else
                  _EmailSent(
                    email: sentTo,
                    isLoading: state.isLoading,
                    onResend: () => context
                        .read<PasswordResetCubit>()
                        .sendResetEmail(sentTo),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmailSent extends StatelessWidget {
  const _EmailSent({
    required this.email,
    required this.isLoading,
    required this.onResend,
  });

  final String email;
  final bool isLoading;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthResetHeader(
          icon: Icons.mark_email_read_outlined,
          title: 'Revisa tu correo',
          subtitle: 'Te enviamos un enlace para restablecer tu contraseña a',
        ),
        const SizedBox(height: 4),
        Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: context.palette.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ábrelo desde este dispositivo para continuar. Si no lo ves, '
          'revisa la carpeta de spam.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.palette.textSecondary),
        ),
        const SizedBox(height: 28),
        AuthPrimaryButton(
          label: 'Volver a iniciar sesión',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: isLoading ? null : onResend,
          style: TextButton.styleFrom(foregroundColor: AppColors.purple),
          child: Text(isLoading ? 'Enviando…' : 'Reenviar correo'),
        ),
      ],
    );
  }
}
