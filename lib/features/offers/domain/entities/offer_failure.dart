import 'package:equatable/equatable.dart';

class OfferFailure extends Equatable implements Exception {
  const OfferFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'OfferFailure: $message';
}
