import 'package:equatable/equatable.dart';

class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.name,
    required this.price,
    this.isActive = true,
  });

  final String id;
  final String name;
  final double price;
  final bool isActive;

  Plan copyWith({String? id, String? name, double? price, bool? isActive}) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, price, isActive];
}
