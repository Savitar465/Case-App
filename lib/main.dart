import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/business/data/datasources/remote/business_remote_data_source.dart';
import 'features/business/data/repositories/business_repository_impl.dart';
import 'features/business/domain/repositories/business_repository.dart';
import 'features/follow/data/datasources/remote/follow_remote_data_source.dart';
import 'features/follow/data/repositories/follow_repository_impl.dart';
import 'features/follow/domain/repositories/follow_repository.dart';
import 'features/items/data/datasources/remote/item_remote_data_source.dart';
import 'features/items/data/repositories/item_repository_impl.dart';
import 'features/items/domain/repositories/item_repository.dart';
import 'features/offers/data/datasources/remote/offer_remote_data_source.dart';
import 'features/offers/data/repositories/offer_repository_impl.dart';
import 'features/offers/domain/repositories/offer_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabase = await _initializeSupabase();
  final dependencies = _buildDependencies(supabase);

  runApp(_AppRoot(dependencies: dependencies));
}

Future<SupabaseClient> _initializeSupabase() async {
  const url = String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (url.isEmpty || anonKey.isEmpty) {
    throw StateError(
      'Supabase credentials are missing. '
      'Provide SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }

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

  final followRepository = FollowRepositoryImpl(
    remoteDataSource: FollowRemoteDataSource(supabase),
  );

  return _AppDependencies(
    authRepository: authRepository,
    businessRepository: businessRepository,
    itemRepository: itemRepository,
    offerRepository: offerRepository,
    followRepository: followRepository,
  );
}

class _AppDependencies {
  const _AppDependencies({
    required this.authRepository,
    required this.businessRepository,
    required this.itemRepository,
    required this.offerRepository,
    required this.followRepository,
  });

  final AuthRepository authRepository;
  final BusinessRepository businessRepository;
  final ItemRepository itemRepository;
  final OfferRepository offerRepository;
  final FollowRepository followRepository;
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
        RepositoryProvider<FollowRepository>.value(
          value: dependencies.followRepository,
        ),
      ],
      child: App(authRepository: dependencies.authRepository),
    );
  }
}
