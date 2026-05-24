import 'package:equatable/equatable.dart';

class ItemFailure extends Equatable implements Exception {
  const ItemFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ItemFailure: $message';
}
