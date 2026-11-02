import '../../domain/entities/pro_subscription.dart';

class ProSubscriptionModel extends ProSubscription {
  const ProSubscriptionModel({
    required super.id,
    required super.businessId,
    required super.planId,
    required super.priceBought,
    super.paymentId,
    required super.startDate,
    required super.endDate,
    super.isActive = true,
    required super.createdAt,
  });

  factory ProSubscriptionModel.fromRemote(Map<String, dynamic> json) {
    return ProSubscriptionModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      planId: json['plan_id'] as String,
      priceBought: (json['price_bought'] as num?)?.toDouble() ?? 0.0,
      paymentId: json['payment_id'] as String?,
      startDate: _parseDateTime(json['start_date']) ?? DateTime.now().toUtc(),
      endDate: _parseDateTime(json['end_date']) ?? DateTime.now().toUtc(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toRemoteMap() {
    return {
      'id': id,
      'business_id': businessId,
      'plan_id': planId,
      'price_bought': priceBought,
      'payment_id': paymentId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toUtc();
  }
}

