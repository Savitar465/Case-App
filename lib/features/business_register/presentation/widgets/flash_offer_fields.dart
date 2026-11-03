import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/catalog_item_draft.dart';

/// Holds the flash-offer form values (price, validity, daily hours, repeat
/// days) shared by the add-item form and the standalone offer form.
class FlashOfferEditor extends ChangeNotifier {
  FlashOfferEditor({FlashOffer? initial}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    startDate = initial?.startDate ?? today;
    endDate = initial?.endDate ?? today;
    startTime = initial?.startTime ?? const TimeOfDay(hour: 8, minute: 0);
    endTime = initial?.endTime ?? const TimeOfDay(hour: 21, minute: 0);
    repeatWeekdays = {...?initial?.repeatWeekdays};
    final price = initial?.price;
    if (price != null) priceController.text = formatAmount(price);
  }

  final TextEditingController priceController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late final Set<int> repeatWeekdays;

  Future<void> pickDate(BuildContext context, {required bool isStart}) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final firstDate = isStart
        ? (startDate.isBefore(todayDate) ? startDate : todayDate)
        : startDate;
    final initial = isStart ? startDate : endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 2),
    );
    if (picked == null) return;
    if (isStart) {
      startDate = picked;
      if (endDate.isBefore(picked)) endDate = picked;
    } else {
      endDate = picked;
    }
    notifyListeners();
  }

  Future<void> pickTime(BuildContext context, {required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked == null) return;
    if (isStart) {
      startTime = picked;
    } else {
      endTime = picked;
    }
    notifyListeners();
  }

  void toggleWeekday(int day) {
    if (!repeatWeekdays.remove(day)) repeatWeekdays.add(day);
    notifyListeners();
  }

  /// Validates against [normalPrice] and returns the offer, or reports the
  /// first problem through [onError] and returns null.
  FlashOffer? build({
    required double normalPrice,
    required ValueChanged<String> onError,
  }) {
    final flashPrice = double.tryParse(priceController.text);
    if (flashPrice == null) {
      onError('Ingresa el precio flash');
      return null;
    }
    if (flashPrice >= normalPrice) {
      onError('El precio flash debe ser menor al precio normal');
      return null;
    }
    final sameDay = startDate == endDate;
    if (sameDay && _toMinutes(endTime) <= _toMinutes(startTime)) {
      onError('La hora de finalización debe ser posterior a la de inicio');
      return null;
    }
    return FlashOffer(
      price: flashPrice,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      repeatWeekdays: Set.unmodifiable(repeatWeekdays),
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  static int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
}

String _two(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

String formatTime(TimeOfDay t) => '${_two(t.hour)}:${_two(t.minute)}';

/// "12" for whole amounts, "12.5" otherwise.
String formatAmount(double value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

/// Purple panel with flash price, validity dates/hours and repeat days.
class FlashOfferFields extends StatelessWidget {
  const FlashOfferFields({super.key, required this.editor});

  final FlashOfferEditor editor;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: editor,
      builder: (context, _) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.palette.purpleSurface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración de oferta flash',
              style: TextStyle(
                color: AppColors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            const FormLabel('Precio flash (con descuento)'),
            PriceStepper(controller: editor.priceController, filled: true),
            const SizedBox(height: 20),
            const Text(
              'Vigencia de la oferta',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: 'Fecha de inicio',
                    value: formatDate(editor.startDate),
                    icon: Icons.calendar_today_outlined,
                    onTap: () => editor.pickDate(context, isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerField(
                    label: 'Fecha de finalización',
                    value: formatDate(editor.endDate),
                    icon: Icons.calendar_today_outlined,
                    onTap: () => editor.pickDate(context, isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: 'Hora de inicio',
                    value: formatTime(editor.startTime),
                    icon: Icons.schedule_outlined,
                    onTap: () => editor.pickTime(context, isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerField(
                    label: 'Hora de finalización',
                    value: formatTime(editor.endTime),
                    icon: Icons.schedule_outlined,
                    onTap: () => editor.pickTime(context, isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const FormLabel('Repetir la oferta (opcional)'),
            _WeekdayPicker(
              selected: editor.repeatWeekdays,
              onToggle: editor.toggleWeekday,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small field label with consistent spacing below it.
class FormLabel extends StatelessWidget {
  const FormLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// "Bs ____ [▲▼]" numeric stepper.
class PriceStepper extends StatelessWidget {
  const PriceStepper({
    super.key,
    required this.controller,
    this.prefixText = 'Bs ',
    this.integerOnly = false,
    this.filled = false,
  });

  final TextEditingController controller;
  final String? prefixText;
  final bool integerOnly;
  final bool filled;

  void _step(int delta) {
    final current = double.tryParse(controller.text) ?? 0;
    final next = (current + delta).clamp(0, double.maxFinite).toDouble();
    controller.text = formatAmount(next);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
        inputFormatters: [
          if (integerOnly)
            FilteringTextInputFormatter.digitsOnly
          else
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          prefixText: prefixText,
          filled: filled,
          fillColor: context.palette.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.palette.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.purple),
          ),
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ArrowButton(
                icon: Icons.keyboard_arrow_up,
                onTap: () => _step(1),
              ),
              _ArrowButton(
                icon: Icons.keyboard_arrow_down,
                onTap: () => _step(-1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 18, color: context.palette.textSecondary),
    );
  }
}

/// Labelled tappable box showing a date or time value.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
        ),
        const SizedBox(height: 6),
        Material(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.palette.border),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.purple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Row of weekday chips (Lun..Dom) for repeating the offer.
class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({required this.selected, required this.onToggle});

  static const _labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 8,
      children: [
        for (var i = 0; i < _labels.length; i++)
          _DayChip(
            label: _labels[i],
            selected: selected.contains(DateTime.monday + i),
            onTap: () => onToggle(DateTime.monday + i),
          ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.purple : context.palette.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 44,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.purple : context.palette.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : context.palette.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
