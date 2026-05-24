import 'dart:async';
import 'dart:io';

import '../../../../core/reactive/replay_subject.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_failure.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/remote/item_remote_data_source.dart';

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl({required ItemRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final ItemRemoteDataSource _remote;
  final Map<String, ReplaySubject<List<Item>>> _subjects = {};

  ReplaySubject<List<Item>> _subjectFor(String businessId) {
    return _subjects.putIfAbsent(
      businessId,
      () => ReplaySubject<List<Item>>(const []),
    );
  }

  @override
  Stream<List<Item>> watchItems(String businessId) =>
      _subjectFor(businessId).stream;

  @override
  Future<void> refreshItems(String businessId) async {
    try {
      _subjectFor(businessId).add(await _remote.fetchItems(businessId));
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<Item?> getItem(String id) async {
    try {
      return await _remote.fetchItemById(id);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  ItemFailure _mapInfraError(Object error) {
    if (error is ItemFailure) return error;
    if (error is ItemRemoteException) return ItemFailure(error.message);
    if (error is SocketException) {
      return const ItemFailure('No internet connection');
    }
    if (error is TimeoutException) {
      return const ItemFailure('Request timed out');
    }
    return ItemFailure(error.toString());
  }
}
