import 'package:equatable/equatable.dart';

class ProSubscription extends Equatable {
  const ProSubscription({
    required this.id,
    required this.businessId,
    required this.planId,
    required this.priceBought,
    this.paymentId,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.createdAt,
  });

  final String id;
  final String businessId;
  final String planId;
  final double priceBought;
  final String? paymentId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;

  ProSubscription copyWith({
    String? id,
    String? businessId,
    String? planId,
    double? priceBought,
    String? paymentId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ProSubscription(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      planId: planId ?? this.planId,
      priceBought: priceBought ?? this.priceBought,
      paymentId: paymentId ?? this.paymentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    businessId,
    planId,
    priceBought,
    paymentId,
    startDate,
    endDate,
    isActive,
    createdAt,
  ];
}

