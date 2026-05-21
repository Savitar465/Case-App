import 'dart:async';
import 'dart:io';

import '../../../../core/reactive/replay_subject.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_failure.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/remote/business_remote_data_source.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl({required BusinessRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final BusinessRemoteDataSource _remote;
  final ReplaySubject<List<Business>> _subject = ReplaySubject<List<Business>>(
    const [],
  );

  @override
  Stream<List<Business>> watchBusinesses() => _subject.stream;

  @override
  Future<void> refreshBusinesses() async {
    try {
      _subject.add(await _remote.fetchBusinesses());
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<Business?> getBusiness(String id) async {
    try {
      return await _remote.fetchBusinessById(id);
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
