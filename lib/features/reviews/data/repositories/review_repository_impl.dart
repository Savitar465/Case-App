import 'dart:async';
import 'dart:io';

import '../../domain/entities/review.dart';
import '../../domain/entities/review_failure.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/remote/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({required ReviewRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final ReviewRemoteDataSource _remote;

  @override
  Future<ReviewStats> getStats(String businessId) async {
    try {
      return await _remote.fetchStats(businessId);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<List<Review>> getReviews(String businessId, {int limit = 20}) async {
    try {
      return await _remote.fetchReviews(businessId, limit: limit);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<Review?> getMyReview(String businessId) async {
    try {
      return await _remote.fetchMyReview(businessId);
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<Review> submitReview({
    required String businessId,
    required int rating,
    String? comment,
  }) async {
    try {
      return await _remote.upsertReview(
        businessId: businessId,
        rating: rating,
        comment: comment,
      );
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  ReviewFailure _mapInfraError(Object error) {
    if (error is ReviewFailure) return error;
    if (error is ReviewRemoteException) return ReviewFailure(error.message);
    if (error is SocketException) {
      return const ReviewFailure('No internet connection');
    }
    if (error is TimeoutException) {
      return const ReviewFailure('Request timed out');
    }
    return ReviewFailure(error.toString());
  }
}
