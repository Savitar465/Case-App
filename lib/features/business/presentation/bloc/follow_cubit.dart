import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/business_failure.dart';
import '../../domain/repositories/business_repository.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit({
    required BusinessRepository repository,
    required String businessId,
    required int initialFollowersCount,
  }) : _repository = repository,
       _businessId = businessId,
       super(FollowState(followersCount: initialFollowersCount));

  final BusinessRepository _repository;
  final String _businessId;

  Future<void> initialize() async {
    try {
      final following = await _repository.isFollowing(_businessId);
      emit(state.copyWith(isFollowing: following));
    } on BusinessFailure {
      // Non-fatal: leave the default (not following) state.
    } catch (_) {}
  }

  Future<void> toggle() async {
    if (state.isToggling) return;
    final wasFollowing = state.isFollowing;
    // Optimistic update so the button feels instant.
    emit(
      state.copyWith(
        isToggling: true,
        isFollowing: !wasFollowing,
        followersCount: (state.followersCount + (wasFollowing ? -1 : 1)).clamp(
          0,
          1 << 31,
        ),
        clearError: true,
      ),
    );
    try {
      final following = await _repository.toggleFollow(_businessId);
      emit(state.copyWith(isToggling: false, isFollowing: following));
    } on BusinessFailure catch (failure) {
      // Roll back.
      emit(
        state.copyWith(
          isToggling: false,
          isFollowing: wasFollowing,
          followersCount: (state.followersCount + (wasFollowing ? 1 : -1))
              .clamp(0, 1 << 31),
          error: failure.message,
        ),
      );
    }
  }

  /// Clears a surfaced error after the UI has shown it.
  void acknowledgeError() => emit(state.copyWith(clearError: true));
}
