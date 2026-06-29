import '../../../market/domain/entities/category.dart';
import '../../domain/entities/business_draft.dart';
import '../../domain/repositories/business_registration_repository.dart';
import '../datasources/remote/business_registration_remote_data_source.dart';

class BusinessRegistrationRepositoryImpl
    implements BusinessRegistrationRepository {
  BusinessRegistrationRepositoryImpl({
    required BusinessRegistrationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final BusinessRegistrationRemoteDataSource _remoteDataSource;

  @override
  Future<List<MarketCategory>> getCategories() =>
      _remoteDataSource.getCategories();

  @override
  Future<String> publish(BusinessDraft draft) =>
      _remoteDataSource.publish(draft);
}
