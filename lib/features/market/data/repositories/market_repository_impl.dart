import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:market_app/core/reactive/replay_subject.dart';
import 'package:market_app/features/market/data/datasources/market_remote_data_source.dart';
import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/domain/entities/market_failure.dart';
import 'package:market_app/features/market/domain/repositories/market_repository.dart';

class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl({required MarketRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final MarketRemoteDataSource _remote;

  // Caché reactivo en memoria (per-session)
  final _categoriesSubject = ReplaySubject<List<MarketCategory>>([]);
  final _businessesSubject = ReplaySubject<List<Business>>([]);

  @override
  Stream<List<Business>> watchBusinesses() => _businessesSubject.stream;

  @override
  Stream<List<MarketCategory>> watchCategories() => _categoriesSubject.stream;

  @override
  Future<void> refresh() async {
    developer.log('MarketRepository: refreshing data...', name: 'market.data');
    try {
      // Cargamos categorías primero
      final categories = await _remote.getCategories();
      developer.log(
        'MarketRepository: Emitting ${categories.length} categories',
        name: 'market.data',
      );
      _categoriesSubject.add(categories);

      // Luego negocios
      final businesses = await _remote.getBusinesses();
      developer.log(
        'MarketRepository: Emitting ${businesses.length} businesses',
        name: 'market.data',
      );
      _businessesSubject.add(businesses);

      developer.log('MarketRepository: Refresh completed', name: 'market.data');
    } catch (e) {
      developer.log(
        'MarketRepository: Error fetching remote data',
        name: 'market.data',
        error: e,
      );
      throw _mapInfraError(e);
    }
  }

  MarketFailure _mapInfraError(Object error) {
    if (error is MarketFailure) return error;
    if (error is MarketRemoteException) return MarketFailure(error.message);
    if (error is SocketException)
      return const MarketFailure('No hay conexión a internet');
    if (error is TimeoutException)
      return const MarketFailure('La solicitud ha tardado demasiado');
    return MarketFailure(error.toString());
  }
}
