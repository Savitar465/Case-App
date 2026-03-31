import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/inventory_location.dart';

class InventoryLocationModel extends Equatable {
  const InventoryLocationModel({
    required this.id,
    required this.type,
    required this.name,
    this.code,
    this.description,
    this.address,
    this.phone,
    this.managerId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  final String id;
  final String type;
  final String name;
  final String? code;
  final String? description;
  final String? address;
  final String? phone;
  final String? managerId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;

  InventoryLocation toEntity() {
    return InventoryLocation(
      id: id,
      type: InventoryLocationTypeX.fromLabel(type),
      name: name,
      code: code,
      description: description,
      address: address,
      phone: phone,
      managerId: managerId,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncedAt: syncedAt,
    );
  }

  InventoryLocationsTableCompanion toCompanion() {
    return InventoryLocationsTableCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      code: Value(code),
      description: Value(description),
      address: Value(address),
      phone: Value(phone),
      managerId: Value(managerId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: Value(syncedAt),
    );
  }

  factory InventoryLocationModel.fromTable(InventoryLocationsTableData data) {
    return InventoryLocationModel(
      id: data.id,
      type: data.type,
      name: data.name,
      code: data.code,
      description: data.description,
      address: data.address,
      phone: data.phone,
      managerId: data.managerId,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      syncedAt: data.syncedAt,
    );
  }

  factory InventoryLocationModel.fromRemote(Map<String, dynamic> data) {
    DateTime? parseDate(dynamic value) {
      if (value is DateTime) {
        return value.toUtc();
      }
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value)?.toUtc();
      }
      return null;
    }

    bool parseBool(dynamic value, {bool fallback = false}) {
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' || normalized == '0') {
          return false;
        }
      }
      return fallback;
    }

    String? parseString(dynamic value) {
      if (value is String && value.isNotEmpty) {
        return value;
      }
      if (value == null) {
        return null;
      }
      final stringified = value.toString();
      return stringified.isEmpty ? null : stringified;
    }

    final dynamic rawId = data['id'];
    if (rawId == null) {
      throw const FormatException('inventory_locations row is missing id');
    }

    final updatedAt = parseDate(data['updated_at']);
    return InventoryLocationModel(
      id: rawId.toString(),
      type: parseString(data['type']) ?? InventoryLocationType.store.label,
      name: parseString(data['name']) ?? '',
      code: parseString(data['code']),
      description: parseString(data['description']),
      address: parseString(data['address']),
      phone: parseString(data['phone']),
      managerId: parseString(data['manager_id']),
      isActive: parseBool(data['is_active'], fallback: true),
      createdAt: parseDate(data['created_at']),
      updatedAt: updatedAt,
      syncedAt: updatedAt,
    );
  }
  factory InventoryLocationModel.fromEntity(InventoryLocation entity) {
    return InventoryLocationModel(
      id: entity.id,
      type: entity.type.label,
      name: entity.name,
      code: entity.code,
      description: entity.description,
      address: entity.address,
      phone: entity.phone,
      managerId: entity.managerId,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
    );
  }

  InventoryLocationModel copyWith({
    String? id,
    String? type,
    String? name,
    String? code,
    String? description,
    String? address,
    String? phone,
    String? managerId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
  }) {
    return InventoryLocationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      managerId: managerId ?? this.managerId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    name,
    code,
    description,
    address,
    phone,
    managerId,
    isActive,
    createdAt,
    updatedAt,
    syncedAt,
  ];
}
