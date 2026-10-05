import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/change_password_use_case.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../bloc/change_password_cubit.dart';
import '../widgets/settings_widgets.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  static const routeName = '/settings/password';

  @override
  Widget build(BuildContext context) {
    final repository = context.read<SettingsRepository>();
    return BlocProvider(
      create: (_) => ChangePasswordCubit(
        loadSettings: LoadAccountSettingsUseCase(repository),
        changePassword: ChangePasswordUseCase(repository),
      )..load(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  static const _minLength = 6;

  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangePasswordCubit>().submit(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );
  }

  String? _validateNew(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Ingresa la nueva contraseña';
    if (password.length < _minLength) {
      return 'Debe tener al menos $_minLength caracteres';
    }
    if (password == _currentController.text) {
      return 'Debe ser distinta a la actual';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: '',
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listenWhen: (prev, curr) =>
            (curr.success && !prev.success) ||
            (curr.error != null && curr.error != prev.error),
        listener: (context, state) {
          if (state.success) {
            showSettingsSnackBar(context, 'Contraseña actualizada');
            Navigator.of(context).pop();
          } else {
            showSettingsSnackBar(context, state.error!);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                Text(
                  state.hasPassword ? 'Cambiar contraseña' : 'Crear contraseña',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.hasPassword
                      ? 'Por favor, introduce tu contraseña actual y la nueva '
                            'que deseas utilizar.'
                      : 'Iniciaste sesión con Google. Crea una contraseña para '
                            'entrar también con tu correo.',
                  style: TextStyle(color: context.palette.textSecondary),
                ),
                const SizedBox(height: 24),
                if (state.hasPassword) ...[
                  SettingsTextField(
                    label: 'Contraseña actual',
                    icon: Icons.shield_outlined,
                    controller: _currentController,
                    obscureText: _hideCurrent,
                    onToggleObscure: () =>
                        setState(() => _hideCurrent = !_hideCurrent),
                    textInputAction: TextInputAction.next,
                    validator: (value) => (value ?? '').isEmpty
                        ? 'Ingresa tu contraseña actual'
                        : null,
                  ),
                  const SizedBox(height: 18),
                ],
                SettingsTextField(
                  label: 'Nueva contraseña',
                  icon: Icons.key_outlined,
                  controller: _newController,
                  obscureText: _hideNew,
                  onToggleObscure: () => setState(() => _hideNew = !_hideNew),
                  textInputAction: TextInputAction.next,
                  validator: _validateNew,
                ),
                const SizedBox(height: 18),
                SettingsTextField(
                  label: 'Confirmar nueva contraseña',
                  icon: Icons.lock_reset,
                  controller: _confirmController,
                  obscureText: _hideConfirm,
                  onToggleObscure: () =>
                      setState(() => _hideConfirm = !_hideConfirm),
                  textInputAction: TextInputAction.done,
                  validator: (value) => value != _newController.text
                      ? 'Las contraseñas no coinciden'
                      : null,
                ),
                const SizedBox(height: 32),
                SettingsPrimaryButton(
                  label: state.hasPassword
                      ? 'Actualizar contraseña'
                      : 'Crear contraseña',
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
