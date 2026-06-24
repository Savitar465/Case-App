import '../entities/review.dart';
import '../entities/review_stats.dart';

abstract class ReviewRepository {
  /// Aggregate rating (average + count) for [businessId].
  Future<ReviewStats> getStats(String businessId);

  /// Most recent reviews for [businessId], newest first.
  Future<List<Review>> getReviews(String businessId, {int limit = 20});

  /// The signed-in user's own review for [businessId], or null when there is
  /// none (or nobody is signed in).
  Future<Review?> getMyReview(String businessId);

  /// Creates or updates the signed-in user's review. Throws
  /// `ReviewFailure.notAuthenticated` when there is no session.
  Future<Review> submitReview({
    required String businessId,
    required int rating,
    String? comment,
  });
}
