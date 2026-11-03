import 'dart:async';
import 'dart:io';

import '../../domain/entities/business_registration_failure.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/entities/catalog_offer.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/remote/catalog_remote_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl({required CatalogRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final CatalogRemoteDataSource _remote;

  @override
  Future<List<CatalogItem>> getItems(String businessId) =>
      _run(() => _remote.fetchItems(businessId));

  @override
  Future<List<CatalogOffer>> getOffers(String businessId) =>
      _run(() => _remote.fetchOffers(businessId));

  @override
  Future<void> addItem(String businessId, CatalogItemDraft draft) =>
      _run(() => _remote.addItem(businessId, draft));

  @override
  Future<void> updateItem(CatalogItem item, CatalogItemDraft draft) =>
      _run(() => _remote.updateItem(item, draft));

  @override
  Future<void> setItemActive(String itemId, {required bool isActive}) =>
      _run(() => _remote.setItemActive(itemId, isActive: isActive));

  @override
  Future<void> deleteItem(CatalogItem item) =>
      _run(() => _remote.deleteItem(item));

  @override
  Future<void> saveOffer({
    required CatalogItem item,
    required FlashOffer offer,
    String? offerId,
  }) =>
      _run(() => _remote.saveOffer(item: item, offer: offer, offerId: offerId));

  @override
  Future<void> setOfferActive(String offerId, {required bool isActive}) =>
      _run(() => _remote.setOfferActive(offerId, isActive: isActive));

  @override
  Future<void> deleteOffer(String offerId) =>
      _run(() => _remote.deleteOffer(offerId));

  Future<T> _run<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  BusinessRegistrationFailure _mapInfraError(Object error) {
    if (error is BusinessRegistrationFailure) return error;
    if (error is CatalogRemoteException) {
      return BusinessRegistrationFailure(error.message);
    }
    if (error is SocketException) {
      return const BusinessRegistrationFailure('Sin conexión a internet');
    }
    if (error is TimeoutException) {
      return const BusinessRegistrationFailure('La solicitud tardó demasiado');
    }
    return BusinessRegistrationFailure(error.toString());
  }
}
