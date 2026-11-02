import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.price,
    super.isActive = true,
  });

  factory PlanModel.fromRemote(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toRemoteMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'is_active': isActive,
    };
  }
}

