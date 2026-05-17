import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/core/constants/app_constants.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:market_app/features/auth/presentation/pages/login_page.dart';
import 'package:market_app/features/business/presentation/pages/business_list_page.dart';

/// Root widget. Wires the auth-scoped Bloc and the top-level routing.
class App extends StatelessWidget {
  App({super.key, required AuthRepository authRepository})
      : _loginUseCase = LoginUseCase(authRepository),
        _logoutUseCase = LogoutUseCase(authRepository),
        _restoreSessionUseCase = RestoreSessionUseCase(authRepository);

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUseCase: _loginUseCase,
        logoutUseCase: _logoutUseCase,
        restoreSessionUseCase: _restoreSessionUseCase,
      )..add(const AuthStarted()),
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const _AuthGate(),
        routes: {
          LoginPage.routeName: (_) => const LoginPage(),
          BusinessListPage.routeName: (_) => const BusinessListPage(),
        },
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => switch (state) {
        AuthAuthenticated() => const BusinessListPage(),
        AuthLoading() => const _LoadingScreen(),
        AuthInitial() || AuthError() => const LoginPage(),
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
