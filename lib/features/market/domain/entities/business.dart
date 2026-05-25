import 'package:equatable/equatable.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.name,
    required this.address,
    this.description,
    this.phone,
    this.isPro = false,
    this.isFeatured = false,
    this.status = 'pending',
    this.viewsCount = 0,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String address;
  final String? description;
  final String? phone;
  final bool isPro;
  final bool isFeatured;
  final String status;
  final int viewsCount;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    description,
    phone,
    isPro,
    isFeatured,
    status,
    viewsCount,
    imageUrl,
    createdAt,
    updatedAt,
  ];
}
