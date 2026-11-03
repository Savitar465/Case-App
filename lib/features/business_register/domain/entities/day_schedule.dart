import 'package:equatable/equatable.dart';

/// One opening interval ("turno") within a day, as "H:MM" 24-hour strings.
class TimeRange extends Equatable {
  const TimeRange({required this.open, required this.close});

  final String open;
  final String close;

  int get openMinutes => _minutes(open);

  int get closeMinutes => _minutes(close);

  TimeRange copyWith({String? open, String? close}) =>
      TimeRange(open: open ?? this.open, close: close ?? this.close);

  Map<String, dynamic> toJson() => {'open': open, 'close': close};

  static int _minutes(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.first.trim()) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1].trim()) ?? 0 : 0;
    return hour * 60 + minute;
  }

  static String format(int minutes) =>
      '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [open, close];
}

/// Opening hours for a single weekday (design img_6), possibly split into
/// several shifts (e.g. 8:00–12:00 and 14:00–19:00).
class DaySchedule extends Equatable {
  const DaySchedule({
    required this.day,
    required this.label,
    this.isOpen = true,
    this.ranges = const [TimeRange(open: '8:00', close: '19:00')],
  });

  /// English key persisted in the `schedule` json column.
  final String day;

  /// Spanish label shown in the UI ("Lunes", "Martes"...).
  final String label;
  final bool isOpen;

  /// Shifts in the order the owner entered them; never empty.
  final List<TimeRange> ranges;

  DaySchedule copyWith({bool? isOpen, List<TimeRange>? ranges}) {
    return DaySchedule(
      day: day,
      label: label,
      isOpen: isOpen ?? this.isOpen,
      ranges: ranges ?? this.ranges,
    );
  }

  DaySchedule updateRange(int index, TimeRange range) =>
      copyWith(ranges: [...ranges]..[index] = range);

  /// Appends a shift starting an hour after the last one closes.
  DaySchedule addRange() {
    const lastStart = 23 * 60;
    const endOfDay = 23 * 60 + 59;
    final start = (ranges.last.closeMinutes + 60).clamp(0, lastStart);
    final end = (start + 180).clamp(0, endOfDay);
    return copyWith(
      ranges: [
        ...ranges,
        TimeRange(open: TimeRange.format(start), close: TimeRange.format(end)),
      ],
    );
  }

  DaySchedule removeRange(int index) {
    if (ranges.length <= 1) return this;
    return copyWith(ranges: [...ranges]..removeAt(index));
  }

  /// First problem with this day's shifts, or null when they are valid.
  /// Overnight shifts (close <= open, e.g. 20:00–2:00) are only allowed as
  /// the last shift of the day.
  String? get validationError {
    if (!isOpen) return null;
    final sorted = [...ranges]
      ..sort((a, b) => a.openMinutes.compareTo(b.openMinutes));
    for (var i = 0; i < sorted.length; i++) {
      final range = sorted[i];
      if (range.openMinutes == range.closeMinutes) {
        return '$label: la hora de apertura y cierre no pueden ser iguales';
      }
      final overnight = range.closeMinutes < range.openMinutes;
      final isLast = i == sorted.length - 1;
      if (overnight && !isLast) {
        return '$label: solo el último turno puede pasar la medianoche';
      }
      if (!isLast && range.closeMinutes > sorted[i + 1].openMinutes) {
        return '$label: los turnos se cruzan';
      }
    }
    return null;
  }

  /// Persisted as a list of `{open, close}` shifts, sorted by opening time;
  /// a closed day is an empty list. This is the shape every schedule reader
  /// in the app understands.
  List<Map<String, dynamic>> toJson() {
    if (!isOpen) return const [];
    final sorted = [...ranges]
      ..sort((a, b) => a.openMinutes.compareTo(b.openMinutes));
    return [for (final range in sorted) range.toJson()];
  }

  /// The default Monday–Sunday week, all open 8:00–19:00.
  static List<DaySchedule> defaultWeek() => const [
    DaySchedule(day: 'monday', label: 'Lunes'),
    DaySchedule(day: 'tuesday', label: 'Martes'),
    DaySchedule(day: 'wednesday', label: 'Miércoles'),
    DaySchedule(day: 'thursday', label: 'Jueves'),
    DaySchedule(day: 'friday', label: 'Viernes'),
    DaySchedule(day: 'saturday', label: 'Sábado'),
    DaySchedule(day: 'sunday', label: 'Domingo'),
  ];

  @override
  List<Object?> get props => [day, label, isOpen, ranges];
}
