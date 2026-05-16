import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'core/security/credential_cipher.dart';
import 'features/auth/data/datasources/local/auth_local_data_source.dart';
import 'features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/inventory/data/datasources/local/inventory_local_data_source.dart';
import 'features/inventory/data/datasources/remote/inventory_remote_data_source.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/repositories/inventory_repository.dart';
import 'features/products/data/datasources/local/product_local_data_source.dart';
import 'features/products/data/datasources/remote/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';

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
  final database = AppDatabase();
  final cipher = CredentialCipher();

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(supabase),
    localDataSource: AuthLocalDataSource(
      database: database,
      credentialCipher: cipher,
    ),
  );

  final productRepository = ProductRepositoryImpl(
    remoteDataSource: ProductRemoteDataSource(supabase),
    localDataSource: ProductLocalDataSource(database),
  );

  final inventoryRepository = InventoryRepositoryImpl(
    localDataSource: InventoryLocalDataSource(database),
    remoteDataSource: InventoryRemoteDataSource(supabase),
    productRepository: productRepository,
  );

  return _AppDependencies(
    authRepository: authRepository,
    productRepository: productRepository,
    inventoryRepository: inventoryRepository,
  );
}

class _AppDependencies {
  const _AppDependencies({
    required this.authRepository,
    required this.productRepository,
    required this.inventoryRepository,
  });

  final AuthRepository authRepository;
  final ProductRepository productRepository;
  final InventoryRepository inventoryRepository;
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
        RepositoryProvider<ProductRepository>.value(
          value: dependencies.productRepository,
        ),
        RepositoryProvider<InventoryRepository>.value(
          value: dependencies.inventoryRepository,
        ),
      ],
      child: App(
        authRepository: dependencies.authRepository,
        productRepository: dependencies.productRepository,
        inventoryRepository: dependencies.inventoryRepository,
      ),
    );
  }
}
