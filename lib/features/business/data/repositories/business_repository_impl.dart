import 'dart:async';
import 'dart:io';

import '../../domain/entities/business.dart';
import '../../domain/entities/business_failure.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/remote/business_remote_data_source.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl({required BusinessRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final BusinessRemoteDataSource _remote;
  final StreamController<List<Business>> _controller =
      StreamController<List<Business>>.broadcast();
  List<Business> _cache = const [];
  bool _initialFetchStarted = false;

  @override
  Stream<List<Business>> watchBusinesses() {
    if (!_initialFetchStarted) {
      _initialFetchStarted = true;
      // Fire-and-forget initial load; errors propagate through the stream.
      unawaited(_loadFromRemote());
    }
    return _controller.stream;
  }

  @override
  Future<void> refreshBusinesses() => _loadFromRemote();

  @override
  Future<Business?> getBusiness(String id) async {
    try {
      return await _remote.fetchBusinessById(id);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  Future<void> _loadFromRemote() async {
    try {
      final businesses = await _remote.fetchBusinesses();
      _cache = businesses;
      _controller.add(_cache);
    } catch (error) {
      _controller.addError(_mapInfraError(error));
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
