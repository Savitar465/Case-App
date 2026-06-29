import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../widgets/register_widgets.dart';

/// Form to add a single service or product (designs img_9 / img_10). Returns a
/// [CatalogItemDraft] via [Navigator.pop].
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
  final _descriptionController = TextEditingController();

  bool _hasDiscount = false;
  int _photoCount = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
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

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('Ingresa el nombre del ${widget.kind.singular}'),
          ),
        );
      return;
    }
    final item = CatalogItemDraft(
      id: _uuid.v4(),
      kind: widget.kind,
      name: name,
      price: double.tryParse(_priceController.text),
      hasDiscount: _hasDiscount,
      discountPrice: _hasDiscount
          ? double.tryParse(_discountController.text)
          : null,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      photoCount: _photoCount,
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    final isService = widget.kind == CatalogItemKind.service;
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
          children: [
            StepTitle(widget.kind.title),
            const SizedBox(height: 20),
            _OutlinedCard(
              child: WizardTextField(
                controller: _nameController,
                hintText: 'Nombre',
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 20),
            _PriceCard(
              priceController: _priceController,
              discountController: _discountController,
              hasDiscount: _hasDiscount,
              onToggleDiscount: (v) => setState(() => _hasDiscount = v),
              onStepPrice: (d) => _step(_priceController, d),
              onStepDiscount: (d) => _step(_discountController, d),
            ),
            const SizedBox(height: 20),
            Text(
              isService ? 'Descripción  (opcional)' : 'Descripción',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            WizardTextField(controller: _descriptionController, maxLines: 4),
            const SizedBox(height: 16),
            _PhotoBox(
              count: _photoCount,
              onTap: () => setState(() => _photoCount++),
            ),
            const SizedBox(height: 28),
            Center(
              child: SizedBox(
                width: 240,
                child: WizardPrimaryButton(
                  label: 'Agregar ${widget.kind.singular}',
                  onPressed: _submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedCard extends StatelessWidget {
  const _OutlinedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kFieldBorder),
      ),
      child: child,
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.priceController,
    required this.discountController,
    required this.hasDiscount,
    required this.onToggleDiscount,
    required this.onStepPrice,
    required this.onStepDiscount,
  });

  final TextEditingController priceController;
  final TextEditingController discountController;
  final bool hasDiscount;
  final ValueChanged<bool> onToggleDiscount;
  final ValueChanged<int> onStepPrice;
  final ValueChanged<int> onStepDiscount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Precio', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          _Stepper(controller: priceController, onStep: onStepPrice),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Activar descuento',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Switch(
                value: hasDiscount,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.purple,
                onChanged: onToggleDiscount,
              ),
            ],
          ),
          if (hasDiscount) ...[
            const SizedBox(height: 8),
            const Text('Precio con descuento', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _Stepper(controller: discountController, onStep: onStepDiscount),
          ],
        ],
      ),
    );
  }
}

/// "Bs ____ [▲▼]" numeric stepper.
class _Stepper extends StatelessWidget {
  const _Stepper({required this.controller, required this.onStep});

  final TextEditingController controller;
  final ValueChanged<int> onStep;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          prefixText: 'Bs ',
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

class _PhotoBox extends StatelessWidget {
  const _PhotoBox({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kFieldBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_photo_alternate, size: 44),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                count == 0
                    ? 'Añadir fotos\n(opcional)'
                    : '$count foto(s) añadida(s)',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
