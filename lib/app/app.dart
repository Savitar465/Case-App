import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:market_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:market_app/features/auth/presentation/pages/login_page.dart';
import 'package:market_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';

import '../features/auth/domain/entities/auth_session.dart';
import '../features/auth/domain/entities/auth_user.dart';
import '../features/inventory/presentation/pages/inventory_home_page.dart';
import '../features/products/presentation/pages/market_home_page.dart';
import '../features/products/presentation/pages/seller_home_page.dart';

class App extends StatelessWidget {
  App({
    super.key,
    required AuthRepository authRepository,
    required ProductRepository productRepository,
    required InventoryRepository inventoryRepository,
  })  : _authRepository = authRepository,
        _productRepository = productRepository,
        _inventoryRepository = inventoryRepository,
        _loginUseCase = LoginUseCase(authRepository),
        _logoutUseCase = LogoutUseCase(authRepository),
        _restoreSessionUseCase = RestoreSessionUseCase(authRepository);

  final AuthRepository _authRepository;
  final ProductRepository _productRepository;
  final InventoryRepository _inventoryRepository;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<ProductRepository>.value(value: _productRepository),
        RepositoryProvider<InventoryRepository>.value(value: _inventoryRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          loginUseCase: _loginUseCase,
          logoutUseCase: _logoutUseCase,
          restoreSessionUseCase: _restoreSessionUseCase,
        )..add(const AuthStarted()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Market App',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              ),
              home: switch (state) {
                AuthAuthenticated(:final session) => _HomeRouter(
                  authenticatedSession: session,
                ),
                AuthLoading() => const _LoadingScreen(),
                _ => const LoginPage(),
              },
              routes: {
                LoginPage.routeName: (_) => const LoginPage(),
                MarketHomePage.routeName: (_) => const MarketHomePage(),
              },
            );
          },
        ),
      ),
    );
  }
}

class _HomeRouter extends StatelessWidget {
  const _HomeRouter({required this.authenticatedSession});

  final AuthSession authenticatedSession;

  @override
  Widget build(BuildContext context) {
    final user = authenticatedSession.user;
    print(user.role);
    if (user.role == UserRole.admin) {
      return InventoryHomePage(session: authenticatedSession);
    }
    if (user.role == UserRole.seller) {
      return SellerHomePage(session: authenticatedSession);
    }
    return const MarketHomePage();
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

