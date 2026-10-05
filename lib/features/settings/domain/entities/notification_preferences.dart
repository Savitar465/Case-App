import 'package:equatable/equatable.dart';

/// Which push / in-app alerts the user wants ("Notificaciones" screen).
class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    this.newOffers = true,
    this.expiringOffers = true,
    this.appMessages = true,
  });

  /// New offers from businesses the user follows.
  final bool newOffers;

  /// Saved offers that are about to expire.
  final bool expiringOffers;

  /// Important messages from the app (account, security, news).
  final bool appMessages;

  /// The "Activar todas las notificaciones" master switch.
  bool get allEnabled => newOffers && expiringOffers && appMessages;

  NotificationPreferences copyWith({
    bool? newOffers,
    bool? expiringOffers,
    bool? appMessages,
  }) {
    return NotificationPreferences(
      newOffers: newOffers ?? this.newOffers,
      expiringOffers: expiringOffers ?? this.expiringOffers,
      appMessages: appMessages ?? this.appMessages,
    );
  }

  @override
  List<Object?> get props => [newOffers, expiringOffers, appMessages];
}
