import 'dart:async';
import 'dart:io';

import '../../../../core/reactive/replay_subject.dart';
import '../../domain/entities/follow.dart';
import '../../domain/entities/follow_failure.dart';
import '../../domain/repositories/follow_repository.dart';
import '../datasources/remote/follow_remote_data_source.dart';

class FollowRepositoryImpl implements FollowRepository {
  FollowRepositoryImpl({required FollowRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final FollowRemoteDataSource _remote;
  final ReplaySubject<List<Follow>> _subject = ReplaySubject<List<Follow>>(
    const [],
  );

  @override
  Stream<List<Follow>> watchFollows() => _subject.stream;

  @override
  Future<void> refreshFollows() async {
    try {
      _subject.add(await _remote.fetchFollows(_remote.currentUserId));
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<void> followBusiness(String businessId) async {
    try {
      await _remote.createFollow(_remote.currentUserId, businessId);
      await refreshFollows();
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<void> unfollowBusiness(String businessId) async {
    try {
      await _remote.deleteFollow(_remote.currentUserId, businessId);
      await refreshFollows();
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  FollowFailure _mapInfraError(Object error) {
    if (error is FollowFailure) return error;
    if (error is FollowRemoteException) return FollowFailure(error.message);
    if (error is SocketException) {
      return const FollowFailure('No internet connection');
    }
    if (error is TimeoutException) {
      return const FollowFailure('Request timed out');
    }
    return FollowFailure(error.toString());
  }
}
