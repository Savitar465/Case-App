import 'package:market_app/features/business/domain/repositories/business_repository.dart';

class RefreshBusinessesUseCase {
  const RefreshBusinessesUseCase(this._repository);

  final BusinessRepository _repository;

  Future<void> call() => _repository.refreshBusinesses();
}
