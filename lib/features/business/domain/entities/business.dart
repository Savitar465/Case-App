import 'package:equatable/equatable.dart';

import 'business_category.dart';
import 'business_status.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    this.description,
    this.phone,
    this.whatsapp,
    this.email,
    this.website,
    this.schedule,
    this.socialNetworks,
    this.isPro = false,
    this.proExpiresAt,
    this.isFeatured = false,
    this.viewsCount = 0,
    this.followersCount = 0,
    this.updatedAt,
    this.updatedBy,
  });

  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final BusinessCategory category;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? website;
  final Map<String, dynamic>? schedule;
  final Map<String, dynamic>? socialNetworks;
  final bool isPro;
  final DateTime? proExpiresAt;
  final bool isFeatured;
  final BusinessStatus status;
  final int viewsCount;
  final int followersCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    description,
    category,
    address,
    latitude,
    longitude,
    phone,
    whatsapp,
    email,
    website,
    schedule,
    socialNetworks,
    isPro,
    proExpiresAt,
    isFeatured,
    status,
    viewsCount,
    followersCount,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ];
}
