import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../market/presentation/pages/market_home_page.dart';
import '../widgets/auth_widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar los Términos y Condiciones'),
          ),
        );
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignupSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text('$feature estará disponible pronto')),
      );
  }

  Future<void> _showConfirmationDialog(String message) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¡Casi listo!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AuthInfo) {
            _showConfirmationDialog(state.message);
          }
          if (state is AuthAuthenticated) {
            Navigator.of(
              context,
            ).pushReplacementNamed(MarketHomePage.routeName);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return AbsorbPointer(
            absorbing: isLoading,
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const VikusAuthHeader(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Crea tu cuenta',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Únete a la comunidad y descubre lo mejor '
                                  'de tu ciudad',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                AuthTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 14),
                                AuthTextField(
                                  controller: _passwordController,
                                  hintText: 'Contraseña',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: _obscure,
                                  onToggleObscure: () =>
                                      setState(() => _obscure = !_obscure),
                                  textInputAction: TextInputAction.next,
                                  validator: _validatePassword,
                                ),
                                const SizedBox(height: 14),
                                AuthTextField(
                                  controller: _confirmController,
                                  hintText: 'Repetir contraseña',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: _obscureConfirm,
                                  onToggleObscure: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  validator: (v) =>
                                      v != _passwordController.text
                                      ? 'Las contraseñas no coinciden'
                                      : null,
                                ),
                                const SizedBox(height: 14),
                                TermsCheckbox(
                                  value: _acceptedTerms,
                                  onChanged: (v) =>
                                      setState(() => _acceptedTerms = v),
                                ),
                                const SizedBox(height: 18),
                                AuthPrimaryButton(
                                  label: 'Crear cuenta',
                                  isLoading: isLoading,
                                  onPressed: _submit,
                                ),
                                const SizedBox(height: 14),
                                GoogleButton(
                                  onPressed: () =>
                                      _comingSoon('El registro con Google'),
                                ),
                                const SizedBox(height: 18),
                                _LoginPrompt(
                                  onTap: () => Navigator.of(context).maybePop(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.chevron_left, size: 28),
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa tu email';
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!pattern.hasMatch(email)) return 'Email inválido';
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Ingresa una contraseña';
    if (password.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes cuenta? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Inicia sesión',
            style: TextStyle(
              color: AppColors.purple,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
