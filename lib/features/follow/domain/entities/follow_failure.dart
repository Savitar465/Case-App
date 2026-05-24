import 'package:equatable/equatable.dart';

class FollowFailure extends Equatable implements Exception {
  const FollowFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'FollowFailure: $message';
}
