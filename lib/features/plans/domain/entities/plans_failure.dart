import 'package:equatable/equatable.dart';

class PlansFailure extends Equatable implements Exception {
  const PlansFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'PlansFailure: $message';
}

