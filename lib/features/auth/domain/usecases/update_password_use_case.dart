import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  const UpdatePasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String newPassword}) =>
      _repository.updatePassword(newPassword: newPassword);
}
