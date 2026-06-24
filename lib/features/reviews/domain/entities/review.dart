import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.authorName,
    required this.rating,
    required this.createdAt,
    this.comment,
  });

  final String id;
  final String businessId;
  final String userId;
  final String authorName;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    businessId,
    userId,
    authorName,
    rating,
    comment,
    createdAt,
  ];
}
