import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../widgets/register_widgets.dart';

/// Form to add a single service or product. Returns a [CatalogItemDraft] via
/// [Navigator.pop].
class CatalogItemFormPage extends StatefulWidget {
  const CatalogItemFormPage({super.key, required this.kind});

  final CatalogItemKind kind;

  @override
  State<CatalogItemFormPage> createState() => _CatalogItemFormPageState();
}

class _CatalogItemFormPageState extends State<CatalogItemFormPage> {
  static const _uuid = Uuid();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Offer configuration.
  OfferType _offerType = OfferType.none;
  late DateTime _startDate;
  late DateTime _endDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 21, minute: 0);
  final Set<int> _repeatWeekdays = {};

  String? _photoPath;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _step(TextEditingController controller, int delta) {
    final current = double.tryParse(controller.text) ?? 0;
    final next = (current + delta).clamp(0, double.maxFinite);
    controller.text = next == next.roundToDouble()
        ? next.toInt().toString()
        : next.toString();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate({required bool isStart}) async {
    final today = DateTime.now();
    final firstDate = isStart
        ? DateTime(today.year, today.month, today.day)
        : _startDate;
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 2),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(picked)) _endDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  Future<void> _pickPhoto() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;
      setState(() => _photoPath = picked.path);
    } catch (_) {
      if (!mounted) return;
      _showError('No se pudo abrir la galería.');
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Ingresa el nombre del ${widget.kind.singular}');
      return;
    }
    final price = double.tryParse(_priceController.text);
    if (price == null) {
      _showError('Ingresa el precio normal');
      return;
    }
    final description = _descriptionController.text.trim();

    FlashOffer? flashOffer;
    if (_offerType == OfferType.flash) {
      final flashPrice = double.tryParse(_discountController.text);
      if (flashPrice == null) {
        _showError('Ingresa el precio flash');
        return;
      }
      if (flashPrice >= price) {
        _showError('El precio flash debe ser menor al precio normal');
        return;
      }
      final sameDay = _startDate == _endDate;
      if (sameDay && _toMinutes(_endTime) <= _toMinutes(_startTime)) {
        _showError('La hora de finalización debe ser posterior a la de inicio');
        return;
      }
      flashOffer = FlashOffer(
        price: flashPrice,
        startDate: _startDate,
        endDate: _endDate,
        startTime: _startTime,
        endTime: _endTime,
        repeatWeekdays: Set.unmodifiable(_repeatWeekdays),
      );
    }

    final item = CatalogItemDraft(
      id: _uuid.v4(),
      kind: widget.kind,
      name: name,
      price: price,
      offerType: _offerType,
      flashOffer: flashOffer,
      quantity: int.tryParse(_quantityController.text),
      description: description.isEmpty ? null : description,
      photoPath: _photoPath,
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: _fields(),
        ),
      ),
    );
  }

  List<Widget> _fields() {
    final isFlash = _offerType == OfferType.flash;
    return [
      StepTitle(widget.kind.title),
      const SizedBox(height: 20),
      const _Label('Nombre'),
      WizardTextField(
        controller: _nameController,
        hintText: widget.kind.nameHint,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 24),
      const _Label('Precio normal'),
      _Stepper(
        controller: _priceController,
        onStep: (d) => _step(_priceController, d),
      ),
      const SizedBox(height: 24),
      const _Label('Tipo de oferta'),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _OfferOption(
                title: 'Sin oferta',
                subtitle: 'Se vende al precio normal',
                selected: !isFlash,
                onTap: () => setState(() => _offerType = OfferType.none),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OfferOption(
                title: 'Oferta flash',
                subtitle: 'Descuento por tiempo corto (horas)',
                icon: Icons.bolt_rounded,
                selected: isFlash,
                onTap: () => setState(() => _offerType = OfferType.flash),
              ),
            ),
          ],
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: isFlash
            ? _flashConfig()
            : const SizedBox(width: double.infinity),
      ),
      const SizedBox(height: 24),
      const _Label('Cantidad disponible'),
      _Stepper(
        controller: _quantityController,
        onStep: (d) => _step(_quantityController, d),
        prefixText: null,
        integerOnly: true,
      ),
      const SizedBox(height: 6),
      const Text(
        'Déjalo vacío si no deseas establecer una cantidad',
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
      const SizedBox(height: 24),
      const _Label('Descripción (opcional)'),
      WizardTextField(controller: _descriptionController, maxLines: 3),
      const SizedBox(height: 24),
      const _Label('Añadir foto (opcional)'),
      _PhotoBox(
        photoPath: _photoPath,
        onTap: _pickPhoto,
        onRemove: () => setState(() => _photoPath = null),
      ),
      const SizedBox(height: 32),
      WizardPrimaryButton(
        label: 'Agregar ${widget.kind.singular}',
        onPressed: _submit,
      ),
    ];
  }

  Widget _flashConfig() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleSurface,
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
          const _Label('Precio flash (con descuento)'),
          _Stepper(
            controller: _discountController,
            onStep: (d) => _step(_discountController, d),
            filled: true,
          ),
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
                  value: _formatDate(_startDate),
                  icon: Icons.calendar_today_outlined,
                  onTap: () => _pickDate(isStart: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerField(
                  label: 'Fecha de finalización',
                  value: _formatDate(_endDate),
                  icon: Icons.calendar_today_outlined,
                  onTap: () => _pickDate(isStart: false),
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
                  value: _formatTime(_startTime),
                  icon: Icons.schedule_outlined,
                  onTap: () => _pickTime(isStart: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerField(
                  label: 'Hora de finalización',
                  value: _formatTime(_endTime),
                  icon: Icons.schedule_outlined,
                  onTap: () => _pickTime(isStart: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _Label('Repetir la oferta (opcional)'),
          _WeekdayPicker(
            selected: _repeatWeekdays,
            onToggle: (day) => setState(() {
              if (!_repeatWeekdays.remove(day)) _repeatWeekdays.add(day);
            }),
          ),
        ],
      ),
    );
  }
}

int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

String _two(int n) => n.toString().padLeft(2, '0');

String _formatDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

String _formatTime(TimeOfDay t) => '${_two(t.hour)}:${_two(t.minute)}';

/// Small field label with consistent spacing below it.
class _Label extends StatelessWidget {
  const _Label(this.text);

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

/// Selectable card for the offer type ("Sin oferta" / "Oferta flash").
class _OfferOption extends StatelessWidget {
  const _OfferOption({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.purpleSurface : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.purple : kFieldBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 20,
                    color: selected ? AppColors.purple : Colors.black38,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (icon != null)
                    Icon(icon, size: 20, color: AppColors.purple),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
      ),
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
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kFieldBorder),
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
      color: selected ? AppColors.purple : Colors.white,
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
              color: selected ? AppColors.purple : kFieldBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

/// "Bs ____ [▲▼]" numeric stepper.
class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.controller,
    required this.onStep,
    this.prefixText = 'Bs ',
    this.integerOnly = false,
    this.filled = false,
  });

  final TextEditingController controller;
  final ValueChanged<int> onStep;
  final String? prefixText;
  final bool integerOnly;
  final bool filled;

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
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kFieldBorder),
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
                onTap: () => onStep(1),
              ),
              _ArrowButton(
                icon: Icons.keyboard_arrow_down,
                onTap: () => onStep(-1),
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
      child: Icon(icon, size: 18, color: Colors.black54),
    );
  }
}

/// Photo dropzone; shows a preview once a photo is picked.
class _PhotoBox extends StatelessWidget {
  const _PhotoBox({
    required this.photoPath,
    required this.onTap,
    required this.onRemove,
  });

  final String? photoPath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    if (path != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(path),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                _PhotoAction(icon: Icons.edit_outlined, onTap: onTap),
                const SizedBox(width: 8),
                _PhotoAction(icon: Icons.close, onTap: onRemove),
              ],
            ),
          ),
        ],
      );
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kFieldBorder),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 44),
            SizedBox(height: 6),
            Text(
              'Toca para elegir una foto',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoAction extends StatelessWidget {
  const _PhotoAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
