import 'package:equatable/equatable.dart';

class BusinessRegistrationFailure extends Equatable implements Exception {
  const BusinessRegistrationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'BusinessRegistrationFailure: $message';
}
