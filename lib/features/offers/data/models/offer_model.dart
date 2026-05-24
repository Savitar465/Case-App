import '../../domain/entities/discount_type.dart';
import '../../domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.businessId,
    required super.title,
    required super.description,
    required super.discountType,
    required super.discountValue,
    required super.startDate,
    required super.endDate,
    required super.isActive,
    required super.createdAt,
    required super.createdBy,
    super.imageUrl,
    super.updatedAt,
    super.updatedBy,
  });

  factory OfferModel.fromRemote(Map<String, dynamic> data) {
    return OfferModel(
      id: data['id'] as String,
      businessId: data['business_id'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      discountType: discountTypeFromLabel(data['discount_type'] as String?),
      discountValue: _readDouble(data['discount_value']) ?? 0,
      startDate: _readDateTime(data['start_date']) ?? DateTime.now().toUtc(),
      endDate: _readDateTime(data['end_date']) ?? DateTime.now().toUtc(),
      imageUrl: data['image_url'] as String?,
      isActive: data['is_active'] as bool? ?? true,
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
}
