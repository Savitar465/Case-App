import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/send_password_reset_email_use_case.dart';
import '../../domain/usecases/update_password_use_case.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/password_reset_cubit.dart';
import '../widgets/auth_widgets.dart';
import 'login_page.dart';

/// "Nueva contraseña": shown when the user opens the reset link. The link has
/// already signed them in, so only the new password is asked for.
class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  static const routeName = '/new-password';

  @override
  Widget build(BuildContext context) {
    final repository = context.read<AuthRepository>();
    return BlocProvider(
      create: (_) => PasswordResetCubit(
        sendPasswordResetEmail: SendPasswordResetEmailUseCase(repository),
        updatePassword: UpdatePasswordUseCase(repository),
      ),
      child: const _NewPasswordView(),
    );
  }
}

class _NewPasswordView extends StatefulWidget {
  const _NewPasswordView();

  @override
  State<_NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<_NewPasswordView> {
  static const _minLength = 6;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<PasswordResetCubit>().updatePassword(_passwordController.text);
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Ingresa la nueva contraseña';
    if (password.length < _minLength) {
      return 'Debe tener al menos $_minLength caracteres';
    }
    return null;
  }

  /// Ends the recovery session so the user signs in with the new password.
  void _finish() {
    context.read<AuthBloc>().add(const LogoutRequested());
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Contraseña actualizada. Inicia sesión de nuevo.'),
        ),
      );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => route.isFirst);
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
            (curr.passwordUpdated && !prev.passwordUpdated) ||
            (curr.error != null && curr.error != prev.error),
        listener: (context, state) {
          if (state.passwordUpdated) {
            _finish();
          } else {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  const AuthResetHeader(
                    icon: Icons.key_outlined,
                    title: 'Nueva contraseña',
                    subtitle:
                        'Crea una contraseña nueva para tu cuenta. Debe tener '
                        'al menos $_minLength caracteres.',
                  ),
                  const SizedBox(height: 28),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: 'Nueva contraseña',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _hidePassword,
                    onToggleObscure: () =>
                        setState(() => _hidePassword = !_hidePassword),
                    textInputAction: TextInputAction.next,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _confirmController,
                    hintText: 'Confirmar contraseña',
                    prefixIcon: Icons.lock_reset,
                    obscureText: _hideConfirm,
                    onToggleObscure: () =>
                        setState(() => _hideConfirm = !_hideConfirm),
                    textInputAction: TextInputAction.done,
                    validator: (value) => value != _passwordController.text
                        ? 'Las contraseñas no coinciden'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  AuthPrimaryButton(
                    label: 'Guardar contraseña',
                    isLoading: state.isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
