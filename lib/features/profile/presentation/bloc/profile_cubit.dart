import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_overview.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required ProfileRepository repository})
    : _repository = repository,
      super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final overview = await _repository.loadOverview();
      emit(state.copyWith(status: ProfileStatus.ready, overview: overview));
    } catch (error) {
      emit(
        state.copyWith(status: ProfileStatus.error, error: error.toString()),
      );
    }
  }

  /// Unfollows a business and optimistically removes it from the list.
  Future<void> unfollow(String businessId) async {
    final overview = state.overview;
    if (overview == null) return;

    final previous = overview.followed;
    final updated = previous
        .where((business) => business.id != businessId)
        .toList();
    emit(state.copyWith(overview: overview.copyWith(followed: updated)));

    try {
      await _repository.unfollow(businessId);
    } catch (_) {
      // Roll back on failure.
      emit(state.copyWith(overview: overview.copyWith(followed: previous)));
    }
  }
}
