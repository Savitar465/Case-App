import 'package:equatable/equatable.dart';

class ReviewFailure extends Equatable implements Exception {
  const ReviewFailure(this.message);

  /// Raised when an action requires a signed-in user but none is present.
  const ReviewFailure.notAuthenticated()
    : message = 'Inicia sesión para dejar una opinión';

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ReviewFailure: $message';
}
