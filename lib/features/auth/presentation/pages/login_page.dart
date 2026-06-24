import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../market/presentation/pages/market_home_page.dart';
import '../widgets/auth_widgets.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _goToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SignupPage()));
  }

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text('$feature estará disponible pronto')),
      );
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VikusAuthHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Iniciar sesión',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Bienvenido de nuevo a tu ciudad',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),
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
                              textInputAction: TextInputAction.done,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Ingresa tu contraseña'
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _comingSoon(
                                  'La recuperación de contraseña',
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.purple,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('¿Olvidaste tu contraseña?'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AuthPrimaryButton(
                              label: 'Iniciar sesión',
                              isLoading: isLoading,
                              onPressed: _submit,
                            ),
                            const SizedBox(height: 16),
                            const LabeledDivider(label: 'o continúa con'),
                            const SizedBox(height: 16),
                            GoogleButton(
                              onPressed: () =>
                                  _comingSoon('El inicio con Google'),
                            ),
                            const SizedBox(height: 20),
                            _SignupPrompt(onTap: _goToSignup),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
}

class _SignupPrompt extends StatelessWidget {
  const _SignupPrompt({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Regístrate',
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
