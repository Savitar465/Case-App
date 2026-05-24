import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/follow.dart';
import '../../domain/entities/follow_failure.dart';
import '../../domain/repositories/follow_repository.dart';

part 'follow_list_state.dart';

class FollowListCubit extends Cubit<FollowListState> {
  FollowListCubit({required FollowRepository repository})
    : _repository = repository,
      super(const FollowListState());

  final FollowRepository _repository;
  StreamSubscription<List<Follow>>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await _subscription?.cancel();
    _subscription = _repository.watchFollows().listen(
      (follows) => emit(state.copyWith(isLoading: false, follows: follows)),
      onError: (Object error, _) {
        final message = error is FollowFailure
            ? error.message
            : error.toString();
        emit(state.copyWith(isLoading: false, error: message));
      },
    );
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.refreshFollows();
      emit(state.copyWith(isLoading: false));
    } on FollowFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> toggle(String businessId) {
    return state.isFollowing(businessId)
        ? unfollow(businessId)
        : follow(businessId);
  }

  Future<void> follow(String businessId) async {
    emit(state.copyWith(clearError: true));
    try {
      await _repository.followBusiness(businessId);
    } on FollowFailure catch (failure) {
      emit(state.copyWith(error: failure.message));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> unfollow(String businessId) async {
    emit(state.copyWith(clearError: true));
    try {
      await _repository.unfollowBusiness(businessId);
    } on FollowFailure catch (failure) {
      emit(state.copyWith(error: failure.message));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
