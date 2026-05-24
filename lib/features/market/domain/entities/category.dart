import 'package:equatable/equatable.dart';

class MarketCategory extends Equatable {
  const MarketCategory({
    required this.id,
    required this.name,
    required this.nameEs,
    this.icon,
    this.order = 0,
  });

  final String id;
  final String name;
  final String nameEs;
  final String? icon;
  final int order;

  @override
  List<Object?> get props => [id, name, nameEs, icon, order];
}
