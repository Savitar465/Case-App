import 'package:equatable/equatable.dart';

/// Thrown by the auth repository when an authentication action cannot be
/// completed (invalid credentials, offline with no cache, etc.).
///
/// The Bloc catches this and emits an `AuthError` state. Lower layers should
/// re-throw infrastructure errors as [AuthFailure]s rather than letting raw
/// exceptions bubble into presentation code.
class AuthFailure extends Equatable implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AuthFailure: $message';
}
