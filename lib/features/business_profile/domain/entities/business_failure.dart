import 'package:equatable/equatable.dart';

class BusinessFailure extends Equatable implements Exception {
  const BusinessFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'BusinessFailure: $message';
}
