import 'package:equatable/equatable.dart';

enum InventoryLocationType { store, warehouse }

extension InventoryLocationTypeX on InventoryLocationType {
  String get label => switch (this) {
        InventoryLocationType.store => 'store',
        InventoryLocationType.warehouse => 'warehouse',
      };

  bool get isStore => this == InventoryLocationType.store;
  bool get isWarehouse => this == InventoryLocationType.warehouse;

  static InventoryLocationType fromLabel(String value) {
    switch (value.toLowerCase()) {
      case 'warehouse':
        return InventoryLocationType.warehouse;
      case 'store':
      default:
        return InventoryLocationType.store;
    }
  }
}

class InventoryLocation extends Equatable {
  const InventoryLocation({
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
  final InventoryLocationType type;
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

  InventoryLocation copyWith({
    String? id,
    InventoryLocationType? type,
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
    return InventoryLocation(
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
