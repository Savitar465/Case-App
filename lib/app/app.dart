import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/core/constants/app_constants.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:market_app/features/auth/presentation/pages/login_page.dart';
import 'package:market_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:market_app/features/inventory/presentation/pages/inventory_home_page.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';
import 'package:market_app/features/products/presentation/pages/market_home_page.dart';
import 'package:market_app/features/products/presentation/pages/seller_home_page.dart';

/// Root widget. Wires the auth-scoped Bloc and the top-level routing.
///
/// Repositories are provided at the composition root in `main.dart`; this
/// widget only depends on them to build the auth use cases consumed by
/// [AuthBloc].
class App extends StatelessWidget {
  App({
    super.key,
    required AuthRepository authRepository,
    required ProductRepository productRepository,
    required InventoryRepository inventoryRepository,
  })  : _loginUseCase = LoginUseCase(authRepository),
        _logoutUseCase = LogoutUseCase(authRepository),
        _restoreSessionUseCase = RestoreSessionUseCase(authRepository),
        // Held for symmetry with the composition root; presentation code
        // resolves these through `context.read<...>()`.
        _productRepository = productRepository,
        _inventoryRepository = inventoryRepository;

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;
  // ignore: unused_field
  final ProductRepository _productRepository;
  // ignore: unused_field
  final InventoryRepository _inventoryRepository;

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
          MarketHomePage.routeName: (_) => const MarketHomePage(),
        },
      ),
    );
  }
}

/// Reacts to auth state changes and routes to the right top-level screen.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => switch (state) {
        AuthAuthenticated(:final session) => _HomeForRole(session: session),
        AuthLoading() => const _LoadingScreen(),
        AuthInitial() || AuthError() => const LoginPage(),
      },
    );
  }
}

class _HomeForRole extends StatelessWidget {
  const _HomeForRole({required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    return switch (session.user.role) {
      UserRole.admin => InventoryHomePage(session: session),
      UserRole.seller => SellerHomePage(session: session),
      UserRole.customer || UserRole.unknown => const MarketHomePage(),
    };
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
