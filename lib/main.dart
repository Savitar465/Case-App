import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/restore_session_use_case.dart';
import 'features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'features/auth/domain/usecases/signup_use_case.dart';
import 'features/auth/domain/usecases/watch_sign_ins_use_case.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/business/data/datasources/remote/business_remote_data_source.dart';
import 'features/business/data/repositories/business_repository_impl.dart';
import 'features/business/domain/repositories/business_repository.dart';
import 'features/business_register/data/datasources/remote/business_registration_remote_data_source.dart';
import 'features/business_register/data/repositories/business_registration_repository_impl.dart';
import 'features/business_register/domain/repositories/business_registration_repository.dart';
import 'features/favorites/data/datasources/remote/favorites_remote_data_source.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/refresh_favorites_use_case.dart';
import 'features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'features/favorites/domain/usecases/watch_favorites_use_case.dart';
import 'features/favorites/presentation/bloc/favorites_cubit.dart';
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
import 'features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/reviews/data/datasources/remote/review_remote_data_source.dart';
import 'features/reviews/data/repositories/review_repository_impl.dart';
import 'features/reviews/domain/repositories/review_repository.dart';
import 'features/settings/data/datasources/remote/settings_remote_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/entities/theme_preference.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/load_account_settings_use_case.dart';
import 'features/settings/domain/usecases/update_theme_preference_use_case.dart';
import 'features/settings/presentation/bloc/appearance_cubit.dart';
import 'features/welcome/presentation/pages/welcome_page.dart';

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

  final profileRepository = ProfileRepositoryImpl(
    remoteDataSource: ProfileRemoteDataSource(supabase),
  );

  final businessRegistrationRepository = BusinessRegistrationRepositoryImpl(
    remoteDataSource: BusinessRegistrationRemoteDataSource(supabase),
  );

  final favoritesRepository = FavoritesRepositoryImpl(
    remoteDataSource: FavoritesRemoteDataSource(supabase),
  );

  final settingsRepository = SettingsRepositoryImpl(
    remoteDataSource: SettingsRemoteDataSource(supabase),
  );

  return _AppDependencies(
    authRepository: authRepository,
    businessRepository: businessRepository,
    itemRepository: itemRepository,
    offerRepository: offerRepository,
    marketRepository: marketRepository,
    reviewRepository: reviewRepository,
    profileRepository: profileRepository,
    businessRegistrationRepository: businessRegistrationRepository,
    favoritesRepository: favoritesRepository,
    settingsRepository: settingsRepository,
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
    required this.profileRepository,
    required this.businessRegistrationRepository,
    required this.favoritesRepository,
    required this.settingsRepository,
  });

  final AuthRepository authRepository;
  final BusinessRepository businessRepository;
  final ItemRepository itemRepository;
  final OfferRepository offerRepository;
  final MarketRepository marketRepository;
  final ReviewRepository reviewRepository;
  final ProfileRepository profileRepository;
  final BusinessRegistrationRepository businessRegistrationRepository;
  final FavoritesRepository favoritesRepository;
  final SettingsRepository settingsRepository;
}

class _AppRoot extends StatelessWidget {
  const _AppRoot({required this.dependencies});

  final _AppDependencies dependencies;

  /// Lets app-wide listeners (favorites errors) show snackbars on any route.
  static final _messengerKey = GlobalKey<ScaffoldMessengerState>();

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
        RepositoryProvider<ProfileRepository>.value(
          value: dependencies.profileRepository,
        ),
        RepositoryProvider<BusinessRegistrationRepository>.value(
          value: dependencies.businessRegistrationRepository,
        ),
        RepositoryProvider<FavoritesRepository>.value(
          value: dependencies.favoritesRepository,
        ),
        RepositoryProvider<SettingsRepository>.value(
          value: dependencies.settingsRepository,
        ),
      ],
      // Bypass temporal del Login para probar la nueva pestaña directamente
      // child: App(authRepository: dependencies.authRepository),
      // AuthBloc se provee por encima del MaterialApp para que el botón de
      // logout (y el LoginPage al que navega) puedan acceder a él.
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              loginUseCase: LoginUseCase(dependencies.authRepository),
              logoutUseCase: LogoutUseCase(dependencies.authRepository),
              restoreSessionUseCase: RestoreSessionUseCase(
                dependencies.authRepository,
              ),
              signUpUseCase: SignUpUseCase(dependencies.authRepository),
              signInWithGoogleUseCase: SignInWithGoogleUseCase(
                dependencies.authRepository,
              ),
              watchSignInsUseCase: WatchSignInsUseCase(
                dependencies.authRepository,
              ),
            ),
          ),
          // Global: hearts on every screen share one favorites state.
          BlocProvider<FavoritesCubit>(
            create: (_) => FavoritesCubit(
              watchFavorites: WatchFavoritesUseCase(
                dependencies.favoritesRepository,
              ),
              refreshFavorites: RefreshFavoritesUseCase(
                dependencies.favoritesRepository,
              ),
              toggleFavorite: ToggleFavoriteUseCase(
                dependencies.favoritesRepository,
              ),
            )..initialize(),
          ),
          // Global: "Apariencia" switches the theme of the whole app.
          BlocProvider<AppearanceCubit>(
            create: (_) => AppearanceCubit(
              loadSettings: LoadAccountSettingsUseCase(
                dependencies.settingsRepository,
              ),
              updateTheme: UpdateThemePreferenceUseCase(
                dependencies.settingsRepository,
              ),
            )..load(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            // Favorites belong to the signed-in user: reload on login/logout.
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (prev, curr) =>
                  curr is AuthAuthenticated || curr is AuthInitial,
              listener: (context, _) {
                context.read<FavoritesCubit>().refresh();
                context.read<AppearanceCubit>().load();
              },
            ),
            BlocListener<FavoritesCubit, FavoritesState>(
              listenWhen: (prev, curr) =>
                  curr.error != null && prev.error != curr.error,
              listener: (_, state) => _messengerKey.currentState?.showSnackBar(
                SnackBar(content: Text(state.error!)),
              ),
            ),
          ],
          child: BlocSelector<AppearanceCubit, AppearanceState, ThemeMode>(
            selector: (state) => switch (state.preference) {
              ThemePreference.system => ThemeMode.system,
              ThemePreference.light => ThemeMode.light,
              ThemePreference.dark => ThemeMode.dark,
            },
            builder: (context, themeMode) => MaterialApp(
              scaffoldMessengerKey: _messengerKey,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              home: const WelcomePage(),
              routes: {
                WelcomePage.routeName: (_) => const WelcomePage(),
                MarketHomePage.routeName: (_) => const MarketHomePage(),
                LoginPage.routeName: (_) => const LoginPage(),
                SignupPage.routeName: (_) => const SignupPage(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
