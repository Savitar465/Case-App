import 'dart:async';
import 'dart:io';

import 'package:market_app/core/reactive/replay_subject.dart';
import 'package:market_app/features/business/data/datasources/remote/business_remote_data_source.dart';
import 'package:market_app/features/business/data/models/business_model.dart';
import 'package:market_app/features/business/domain/entities/business.dart';
import 'package:market_app/features/business/domain/entities/business_failure.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl({required BusinessRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final BusinessRemoteDataSource _remoteDataSource;
  final ReplaySubject<List<BusinessModel>> _cache =
      ReplaySubject<List<BusinessModel>>(const []);

  @override
  Stream<List<Business>> watchBusinesses() =>
      _cache.stream.map((models) => List<Business>.unmodifiable(models));

  @override
  Future<void> refreshBusinesses() async {
    try {
      final remote = await _remoteDataSource.fetchBusinesses();
      _cache.add(List.unmodifiable(remote));
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  BusinessFailure _mapInfraError(Object error) {
    if (error is BusinessFailure) return error;
    if (error is BusinessRemoteException) return BusinessFailure(error.message);
    if (error is SocketException) {
      return const BusinessFailure('No internet connection');
    }
    if (error is TimeoutException) {
      return const BusinessFailure('Request timed out');
    }
    return BusinessFailure(error.toString());
  }
}
