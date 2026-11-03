import 'dart:async';
import 'dart:io';

import '../../../market/domain/entities/category.dart';
import '../../domain/entities/business_draft.dart';
import '../../domain/entities/business_registration_failure.dart';
import '../../domain/entities/editable_business.dart';
import '../../domain/entities/editable_photo.dart';
import '../../domain/repositories/business_registration_repository.dart';
import '../datasources/remote/business_registration_remote_data_source.dart';

class BusinessRegistrationRepositoryImpl
    implements BusinessRegistrationRepository {
  BusinessRegistrationRepositoryImpl({
    required BusinessRegistrationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final BusinessRegistrationRemoteDataSource _remoteDataSource;

  @override
  Future<List<MarketCategory>> getCategories() async {
    try {
      return await _remoteDataSource.getCategories();
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<String> publish(BusinessDraft draft) async {
    try {
      return await _remoteDataSource.publish(draft);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<EditableBusiness> getBusinessForEdit(String businessId) async {
    try {
      return await _remoteDataSource.fetchBusinessForEdit(businessId);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<void> updateBusiness({
    required String businessId,
    required BusinessDraft draft,
    List<EditablePhoto>? photos,
    List<EditablePhoto>? removedPhotos,
  }) async {
    try {
      await _remoteDataSource.updateBusiness(
        businessId: businessId,
        draft: draft,
        photos: photos,
        removedPhotos: removedPhotos,
      );
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<void> deleteBusiness(String businessId) async {
    try {
      await _remoteDataSource.deleteBusiness(businessId);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  BusinessRegistrationFailure _mapInfraError(Object error) {
    if (error is BusinessRegistrationFailure) return error;
    if (error is BusinessRegistrationException) {
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
