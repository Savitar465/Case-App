part of 'review_list_cubit.dart';

class ReviewListState extends Equatable {
  const ReviewListState({
    this.stats = ReviewStats.empty,
    this.reviews = const [],
    this.myReview,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  final ReviewStats stats;
  final List<Review> reviews;
  final Review? myReview;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  bool get hasReviews => reviews.isNotEmpty;

  ReviewListState copyWith({
    ReviewStats? stats,
    List<Review>? reviews,
    Review? myReview,
    bool clearMyReview = false,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return ReviewListState(
      stats: stats ?? this.stats,
      reviews: reviews ?? this.reviews,
      myReview: clearMyReview ? null : myReview ?? this.myReview,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    stats,
    reviews,
    myReview,
    isLoading,
    isSubmitting,
    error,
  ];
}
