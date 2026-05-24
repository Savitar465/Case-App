import 'package:equatable/equatable.dart';

/// A single open interval within a day, e.g. 08:00–14:00.
class ScheduleInterval extends Equatable {
  const ScheduleInterval({
    required this.openMinutes,
    required this.closeMinutes,
  });

  /// Minutes from midnight (0–1439).
  final int openMinutes;
  final int closeMinutes;

  /// Handles overnight intervals (e.g. 20:00–02:00) where close <= open.
  bool contains(int minutes) {
    if (closeMinutes <= openMinutes) {
      return minutes >= openMinutes || minutes < closeMinutes;
    }
    return minutes >= openMinutes && minutes < closeMinutes;
  }

  String get openLabel => _format(openMinutes);

  String get closeLabel => _format(closeMinutes);

  static int? _parse(dynamic value) {
    if (value is! String) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  static String _format(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [openMinutes, closeMinutes];
}

/// Current open/closed state plus a short human label for the profile line.
class ScheduleStatus {
  const ScheduleStatus({required this.isOpen, required this.detail});

  final bool isOpen;
  final String detail;
}

/// Weekly opening hours parsed from the `schedule` jsonb column.
///
/// Expected JSON shape (24-hour "HH:MM", business local time):
/// ```json
/// {
///   "monday":    [{ "open": "08:00", "close": "14:00" }],
///   "tuesday":   [{ "open": "08:00", "close": "14:00" }, { "open": "16:00", "close": "20:00" }],
///   "sunday":    []
/// }
/// ```
/// An empty list (or a missing day) means closed that day.
class BusinessSchedule extends Equatable {
  const BusinessSchedule(this.intervalsByWeekday);

  /// Keyed by [DateTime.weekday] (1 = Monday … 7 = Sunday).
  final Map<int, List<ScheduleInterval>> intervalsByWeekday;

  static const Map<int, String> _weekdayKeys = {
    1: 'monday',
    2: 'tuesday',
    3: 'wednesday',
    4: 'thursday',
    5: 'friday',
    6: 'saturday',
    7: 'sunday',
  };

  factory BusinessSchedule.fromMap(Map<String, dynamic> map) {
    final result = <int, List<ScheduleInterval>>{};
    _weekdayKeys.forEach((weekday, key) {
      final raw = map[key];
      final intervals = <ScheduleInterval>[];
      if (raw is List) {
        for (final item in raw) {
          if (item is Map) {
            final open = ScheduleInterval._parse(item['open']);
            final close = ScheduleInterval._parse(item['close']);
            if (open != null && close != null) {
              intervals.add(
                ScheduleInterval(openMinutes: open, closeMinutes: close),
              );
            }
          }
        }
      }
      if (intervals.isNotEmpty) result[weekday] = intervals;
    });
    return BusinessSchedule(result);
  }

  List<ScheduleInterval> intervalsFor(int weekday) =>
      intervalsByWeekday[weekday] ?? const [];

  ScheduleStatus statusAt(DateTime now) {
    final minutes = now.hour * 60 + now.minute;
    final today = intervalsFor(now.weekday);

    for (final interval in today) {
      if (interval.contains(minutes)) {
        return ScheduleStatus(
          isOpen: true,
          detail: 'Cierra a las ${interval.closeLabel}',
        );
      }
    }

    ScheduleInterval? nextToday;
    for (final interval in today) {
      if (interval.openMinutes > minutes) {
        if (nextToday == null || interval.openMinutes < nextToday.openMinutes) {
          nextToday = interval;
        }
      }
    }
    if (nextToday != null) {
      return ScheduleStatus(
        isOpen: false,
        detail: 'Abre a las ${nextToday.openLabel}',
      );
    }

    return const ScheduleStatus(isOpen: false, detail: 'Cerrado hoy');
  }

  @override
  List<Object?> get props => [intervalsByWeekday];
}
