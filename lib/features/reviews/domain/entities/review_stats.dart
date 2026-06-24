import 'package:equatable/equatable.dart';

/// Aggregate rating for a business (computed from its review rows).
class ReviewStats extends Equatable {
  const ReviewStats({required this.average, required this.count});

  static const empty = ReviewStats(average: 0, count: 0);

  final double average;
  final int count;

  bool get hasReviews => count > 0;

  @override
  List<Object?> get props => [average, count];
}
