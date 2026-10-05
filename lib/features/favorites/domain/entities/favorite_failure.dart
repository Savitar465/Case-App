import 'package:equatable/equatable.dart';

class FavoriteFailure extends Equatable implements Exception {
  const FavoriteFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'FavoriteFailure: $message';
}
