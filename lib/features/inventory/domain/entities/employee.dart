import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.authUserId,
    required this.role,
    this.locationId,
    this.locationType,
    this.isActive = true,
    this.hiredAt,
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  final String id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? authUserId;
  final String role;
  final String? locationId;
  final String? locationType;
  final bool isActive;
  final DateTime? hiredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;

  String get displayName => [
    firstName,
    if (lastName != null && lastName!.isNotEmpty) lastName,
  ].join(' ').trim();

  Employee copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? authUserId,
    String? role,
    String? locationId,
    String? locationType,
    bool? isActive,
    DateTime? hiredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      authUserId: authUserId ?? this.authUserId,
      role: role ?? this.role,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      isActive: isActive ?? this.isActive,
      hiredAt: hiredAt ?? this.hiredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    authUserId,
    role,
    locationId,
    locationType,
    isActive,
    hiredAt,
    createdAt,
    updatedAt,
    syncedAt,
  ];
}
