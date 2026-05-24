import 'dart:async';
import 'dart:io';

import '../../../../core/reactive/replay_subject.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/offer_failure.dart';
import '../../domain/repositories/offer_repository.dart';
import '../datasources/remote/offer_remote_data_source.dart';

class OfferRepositoryImpl implements OfferRepository {
  OfferRepositoryImpl({required OfferRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final OfferRemoteDataSource _remote;
  final Map<String, ReplaySubject<List<Offer>>> _subjects = {};

  ReplaySubject<List<Offer>> _subjectFor(String businessId) {
    return _subjects.putIfAbsent(
      businessId,
      () => ReplaySubject<List<Offer>>(const []),
    );
  }

  @override
  Stream<List<Offer>> watchOffers(String businessId) =>
      _subjectFor(businessId).stream;

  @override
  Future<void> refreshOffers(String businessId) async {
    try {
      _subjectFor(businessId).add(await _remote.fetchOffers(businessId));
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<Offer?> getOffer(String id) async {
    try {
      return await _remote.fetchOfferById(id);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  OfferFailure _mapInfraError(Object error) {
    if (error is OfferFailure) return error;
    if (error is OfferRemoteException) return OfferFailure(error.message);
    if (error is SocketException) {
      return const OfferFailure('No internet connection');
    }
    if (error is TimeoutException) {
      return const OfferFailure('Request timed out');
    }
    return OfferFailure(error.toString());
  }
}
