import 'package:equatable/equatable.dart';

class MarketFailure extends Equatable implements Exception {
  const MarketFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
  @override
  String toString() => 'MarketFailure: $message';
}
