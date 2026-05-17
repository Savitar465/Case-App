import 'package:market_app/features/business/domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    super.description,
    super.logoUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory BusinessModel.fromRemote(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic value) {
      if (value is DateTime) return value.toUtc();
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value)?.toUtc();
      }
      return null;
    }

    String? parseString(dynamic value) {
      if (value == null) return null;
      final s = value.toString();
      return s.isEmpty ? null : s;
    }

    final id = parseString(map['id'] ?? map['business_id']);
    if (id == null) {
      throw const FormatException('business row is missing id');
    }

    final name = parseString(
      map['name'] ?? map['business_name'] ?? map['store_name'],
    );
    if (name == null) {
      throw const FormatException('business row is missing name');
    }

    return BusinessModel(
      id: id,
      name: name,
      description: parseString(map['description']),
      logoUrl: parseString(map['logo_url'] ?? map['logoUrl']),
      createdAt: parseDate(map['created_at'] ?? map['createdAt']),
      updatedAt: parseDate(map['updated_at'] ?? map['updatedAt']),
    );
  }
}
