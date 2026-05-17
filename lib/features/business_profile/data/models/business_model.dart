import '../../domain/entities/business.dart';
import '../../domain/entities/business_category.dart';
import '../../domain/entities/business_status.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.category,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.createdAt,
    required super.createdBy,
    super.description,
    super.phone,
    super.whatsapp,
    super.email,
    super.website,
    super.schedule,
    super.socialNetworks,
    super.isPro,
    super.proExpiresAt,
    super.isFeatured,
    super.viewsCount,
    super.followersCount,
    super.updatedAt,
    super.updatedBy,
  });

  factory BusinessModel.fromRemote(Map<String, dynamic> data) {
    return BusinessModel(
      id: data['id'] as String,
      ownerId: data['owner_id'] as String,
      name: data['name'] as String,
      description: data['description'] as String?,
      category: businessCategoryFromLabel(
        data['category_id']?.toString() ?? data['category'] as String?,
      ),
      address: data['address'] as String,
      latitude: _readDouble(data['latitude']) ?? 0,
      longitude: _readDouble(data['longitude']) ?? 0,
      phone: data['phone'] as String?,
      whatsapp: data['whatsapp'] as String?,
      email: data['email'] as String?,
      website: data['website'] as String?,
      schedule: _readJsonMap(data['schedule']),
      socialNetworks: _readJsonMap(data['social_networks']),
      isPro: data['is_pro'] as bool? ?? false,
      proExpiresAt: _readDateTime(data['pro_expires_at']),
      isFeatured: data['is_featured'] as bool? ?? false,
      status: businessStatusFromLabel(data['status'] as String?),
      viewsCount: (data['views_count'] as num?)?.toInt() ?? 0,
      followersCount: (data['followers_count'] as num?)?.toInt() ?? 0,
      createdAt: _readDateTime(data['created_at']) ?? DateTime.now().toUtc(),
      updatedAt: _readDateTime(data['updated_at']),
      createdBy: data['created_by'] as String? ?? '',
      updatedBy: data['updated_by'] as String?,
    );
  }

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toUtc();
  }

  static Map<String, dynamic>? _readJsonMap(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }
}
