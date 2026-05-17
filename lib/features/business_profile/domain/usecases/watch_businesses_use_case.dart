import '../entities/business.dart';
import '../repositories/business_repository.dart';

class WatchBusinessesUseCase {
  const WatchBusinessesUseCase(this._repository);

  final BusinessRepository _repository;

  Stream<List<Business>> call() => _repository.watchBusinesses();
}
