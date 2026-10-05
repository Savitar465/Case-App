import 'package:equatable/equatable.dart';

/// A single open interval within a day, in minutes since midnight.
/// [closeMinutes] may exceed 1440 when the business closes after midnight.
class OpeningRange extends Equatable {
  const OpeningRange({required this.openMinutes, required this.closeMinutes});

  final int openMinutes;
  final int closeMinutes;

  /// Covers the whole day (e.g. a 24h pharmacy).
  bool get isAllDay => openMinutes == 0 && closeMinutes >= 1440;

  bool contains(int minutes) =>
      minutes >= openMinutes && minutes < closeMinutes;

  /// "19:00"-style label for the closing time.
  String get closeLabel {
    final minutes = closeMinutes % 1440;
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [openMinutes, closeMinutes];
}

/// Weekly opening hours keyed by [DateTime.weekday] (1 = Monday … 7 = Sunday).
class OpeningHours extends Equatable {
  const OpeningHours([this.days = const {}]);

  final Map<int, List<OpeningRange>> days;

  bool get isKnown => days.isNotEmpty;

  /// The range [time] falls into, or null when the business is closed then.
  OpeningRange? currentRange(DateTime time) {
    final minutes = time.hour * 60 + time.minute;
    for (final range in days[time.weekday] ?? const <OpeningRange>[]) {
      if (range.contains(minutes)) return range;
    }
    return null;
  }

  @override
  List<Object?> get props => [days];
}
