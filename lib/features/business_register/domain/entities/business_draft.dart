import 'package:equatable/equatable.dart';

import '../../../market/domain/entities/category.dart';
import 'catalog_item_draft.dart';
import 'day_schedule.dart';

/// Accumulates every answer in the multi-step business registration wizard.
class BusinessDraft extends Equatable {
  BusinessDraft({
    this.name = '',
    this.category,
    this.address = '',
    this.latitude,
    this.longitude,
    this.whatsappCountryCode = '+591',
    this.whatsapp = '',
    this.tiktok = '',
    this.facebook = '',
    this.instagram = '',
    this.website = '',
    List<DaySchedule>? schedule,
    this.photoCount = 0,
    this.services = const [],
    this.products = const [],
  }) : schedule = schedule ?? DaySchedule.defaultWeek();

  final String name;
  final MarketCategory? category;
  final String address;
  final double? latitude;
  final double? longitude;
  final String whatsappCountryCode;
  final String whatsapp;
  final String tiktok;
  final String facebook;
  final String instagram;
  final String website;
  final List<DaySchedule> schedule;
  final int photoCount;
  final List<CatalogItemDraft> services;
  final List<CatalogItemDraft> products;

  BusinessDraft copyWith({
    String? name,
    MarketCategory? category,
    String? address,
    double? latitude,
    double? longitude,
    String? whatsappCountryCode,
    String? whatsapp,
    String? tiktok,
    String? facebook,
    String? instagram,
    String? website,
    List<DaySchedule>? schedule,
    int? photoCount,
    List<CatalogItemDraft>? services,
    List<CatalogItemDraft>? products,
  }) {
    return BusinessDraft(
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      whatsappCountryCode: whatsappCountryCode ?? this.whatsappCountryCode,
      whatsapp: whatsapp ?? this.whatsapp,
      tiktok: tiktok ?? this.tiktok,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      schedule: schedule ?? this.schedule,
      photoCount: photoCount ?? this.photoCount,
      services: services ?? this.services,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [
    name,
    category,
    address,
    latitude,
    longitude,
    whatsappCountryCode,
    whatsapp,
    tiktok,
    facebook,
    instagram,
    website,
    schedule,
    photoCount,
    services,
    products,
  ];
}
