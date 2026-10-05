import 'package:equatable/equatable.dart';

class SettingsFailure extends Equatable implements Exception {
  const SettingsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'SettingsFailure: $message';
}
