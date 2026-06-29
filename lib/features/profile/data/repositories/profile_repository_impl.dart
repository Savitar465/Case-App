import '../../domain/entities/profile_overview.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileOverview> loadOverview() => _remoteDataSource.loadOverview();

  @override
  Future<void> unfollow(String businessId) =>
      _remoteDataSource.unfollow(businessId);
}
