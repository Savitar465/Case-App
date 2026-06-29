import 'package:equatable/equatable.dart';

/// Opening hours for a single weekday (design img_6).
class DaySchedule extends Equatable {
  const DaySchedule({
    required this.day,
    required this.label,
    this.isOpen = true,
    this.open = '8:00',
    this.close = '19:00',
  });

  /// English key persisted in the `schedule` jsonb column.
  final String day;

  /// Spanish label shown in the UI ("Lunes", "Martes"...).
  final String label;
  final bool isOpen;
  final String open;
  final String close;

  DaySchedule copyWith({bool? isOpen, String? open, String? close}) {
    return DaySchedule(
      day: day,
      label: label,
      isOpen: isOpen ?? this.isOpen,
      open: open ?? this.open,
      close: close ?? this.close,
    );
  }

  Map<String, dynamic> toJson() => {
    'is_open': isOpen,
    'open': open,
    'close': close,
  };

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
  List<Object?> get props => [day, label, isOpen, open, close];
}
