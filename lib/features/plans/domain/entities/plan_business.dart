import 'package:equatable/equatable.dart';

class PlanBusiness extends Equatable {
  const PlanBusiness({
    required this.id,
    required this.name,
    this.address = '',
    this.imageUrl,
    this.isPro = false,
    this.proExpiresAt,
  });

  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final bool isPro;
  final DateTime? proExpiresAt;

  PlanBusiness copyWith({
    String? id,
    String? name,
    String? address,
    String? imageUrl,
    bool? isPro,
    DateTime? proExpiresAt,
  }) {
    return PlanBusiness(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      isPro: isPro ?? this.isPro,
      proExpiresAt: proExpiresAt ?? this.proExpiresAt,
    );
  }

  @override
  List<Object?> get props => [id, name, address, imageUrl, isPro, proExpiresAt];
}
