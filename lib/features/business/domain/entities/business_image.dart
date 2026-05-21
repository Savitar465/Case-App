import 'package:equatable/equatable.dart';

class BusinessImage extends Equatable {
  const BusinessImage({
    required this.id,
    required this.businessId,
    required this.url,
    required this.isCover,
    required this.displayOrder,
    required this.createdAt,
  });

  final String id;
  final String businessId;
  final String url;
  final bool isCover;
  final int displayOrder;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    businessId,
    url,
    isCover,
    displayOrder,
    createdAt,
  ];
}
