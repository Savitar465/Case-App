import 'package:market_app/features/market/domain/entities/category.dart';

class CategoryModel extends MarketCategory {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.nameEs,
    super.icon,
    super.order,
  });

  factory CategoryModel.fromRemote(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEs: json['name_es'] as String,
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }
}
