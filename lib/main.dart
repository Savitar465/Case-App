import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/restore_session_use_case.dart';
import 'features/auth/domain/usecases/signup_use_case.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/business/data/datasources/remote/business_remote_data_source.dart';
import 'features/business/data/repositories/business_repository_impl.dart';
import 'features/business/domain/repositories/business_repository.dart';
import 'features/items/data/datasources/remote/item_remote_data_source.dart';
import 'features/items/data/repositories/item_repository_impl.dart';
import 'features/items/domain/repositories/item_repository.dart';
import 'features/market/data/datasources/market_remote_data_source.dart';
import 'features/market/data/repositories/market_repository_impl.dart';
import 'features/market/domain/repositories/market_repository.dart';
import 'features/market/presentation/pages/market_home_page.dart';
import 'features/offers/data/datasources/remote/offer_remote_data_source.dart';
import 'features/offers/data/repositories/offer_repository_impl.dart';
import 'features/offers/domain/repositories/offer_repository.dart';
import 'features/reviews/data/datasources/remote/review_remote_data_source.dart';
import 'features/reviews/data/repositories/review_repository_impl.dart';
import 'features/reviews/domain/repositories/review_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabase = await _initializeSupabase();
  final dependencies = _buildDependencies(supabase);

  runApp(_AppRoot(dependencies: dependencies));
}

Future<SupabaseClient> _initializeSupabase() async {
  final rawUrl = const String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (rawUrl.isEmpty || anonKey.isEmpty) {
    throw StateError(
      'Supabase credentials are missing. '
      'Provide SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }

  // Sanitizamos la URL: eliminamos espacios, barras finales y el sufijo /rest/v1 si existe
  final url = rawUrl
      .trim()
      .replaceAll(RegExp(r'/rest/v1/?$'), '')
      .replaceAll(RegExp(r'/$'), '');

  await Supabase.initialize(url: url, anonKey: anonKey);
  return Supabase.instance.client;
}

_AppDependencies _buildDependencies(SupabaseClient supabase) {
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(supabase),
  );

  final businessRepository = BusinessRepositoryImpl(
    remoteDataSource: BusinessRemoteDataSource(supabase),
  );

  final itemRepository = ItemRepositoryImpl(
    remoteDataSource: ItemRemoteDataSource(supabase),
  );

  final offerRepository = OfferRepositoryImpl(
    remoteDataSource: OfferRemoteDataSource(supabase),
  );

  final marketRepository = MarketRepositoryImpl(
    remoteDataSource: MarketRemoteDataSource(supabase),
  );

  final reviewRepository = ReviewRepositoryImpl(
    remoteDataSource: ReviewRemoteDataSource(supabase),
  );

  return _AppDependencies(
    authRepository: authRepository,
    businessRepository: businessRepository,
    itemRepository: itemRepository,
    offerRepository: offerRepository,
    marketRepository: marketRepository,
    reviewRepository: reviewRepository,
  );
}

class _AppDependencies {
  const _AppDependencies({
    required this.authRepository,
    required this.businessRepository,
    required this.itemRepository,
    required this.offerRepository,
    required this.marketRepository,
    required this.reviewRepository,
  });

  final AuthRepository authRepository;
  final BusinessRepository businessRepository;
  final ItemRepository itemRepository;
  final OfferRepository offerRepository;
  final MarketRepository marketRepository;
  final ReviewRepository reviewRepository;
}

class _AppRoot extends StatelessWidget {
  const _AppRoot({required this.dependencies});

  final _AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(
          value: dependencies.authRepository,
        ),
        RepositoryProvider<BusinessRepository>.value(
          value: dependencies.businessRepository,
        ),
        RepositoryProvider<ItemRepository>.value(
          value: dependencies.itemRepository,
        ),
        RepositoryProvider<OfferRepository>.value(
          value: dependencies.offerRepository,
        ),
        RepositoryProvider<MarketRepository>.value(
          value: dependencies.marketRepository,
        ),
        RepositoryProvider<ReviewRepository>.value(
          value: dependencies.reviewRepository,
        ),
      ],
      // Bypass temporal del Login para probar la nueva pestaña directamente
      // child: App(authRepository: dependencies.authRepository),
      // AuthBloc se provee por encima del MaterialApp para que el botón de
      // logout (y el LoginPage al que navega) puedan acceder a él.
      child: BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          loginUseCase: LoginUseCase(dependencies.authRepository),
          logoutUseCase: LogoutUseCase(dependencies.authRepository),
          restoreSessionUseCase: RestoreSessionUseCase(
            dependencies.authRepository,
          ),
          signUpUseCase: SignUpUseCase(dependencies.authRepository),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const MarketHomePage(),
          routes: {
            MarketHomePage.routeName: (_) => const MarketHomePage(),
            LoginPage.routeName: (_) => const LoginPage(),
            SignupPage.routeName: (_) => const SignupPage(),
          },
        ),
      ),
    );
  }
}
