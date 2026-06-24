import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/review.dart';
import '../../domain/entities/review_failure.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';

part 'review_list_state.dart';

class ReviewListCubit extends Cubit<ReviewListState> {
  ReviewListCubit({
    required ReviewRepository repository,
    required String businessId,
  }) : _repository = repository,
       _businessId = businessId,
       super(const ReviewListState());

  final ReviewRepository _repository;
  final String _businessId;

  Future<void> initialize() => _load(showSpinner: true);

  Future<void> refresh() => _load(showSpinner: false);

  Future<void> _load({required bool showSpinner}) async {
    if (showSpinner) emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final results = await Future.wait([
        _repository.getStats(_businessId),
        _repository.getReviews(_businessId),
        _repository.getMyReview(_businessId),
      ]);
      emit(
        state.copyWith(
          isLoading: false,
          stats: results[0] as ReviewStats,
          reviews: results[1] as List<Review>,
          myReview: results[2] as Review?,
          clearMyReview: results[2] == null,
        ),
      );
    } on ReviewFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  /// Submits a review. Returns true on success so the caller can close a sheet.
  Future<bool> submit({required int rating, String? comment}) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repository.submitReview(
        businessId: _businessId,
        rating: rating,
        comment: comment,
      );
      emit(state.copyWith(isSubmitting: false));
      await refresh();
      return true;
    } on ReviewFailure catch (failure) {
      emit(state.copyWith(isSubmitting: false, error: failure.message));
      return false;
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, error: error.toString()));
      return false;
    }
  }
}
