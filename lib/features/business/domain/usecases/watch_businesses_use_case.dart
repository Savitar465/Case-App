import 'package:market_app/features/business/domain/entities/business.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';

class WatchBusinessesUseCase {
  const WatchBusinessesUseCase(this._repository);

  final BusinessRepository _repository;

  Stream<List<Business>> call() => _repository.watchBusinesses();
}
