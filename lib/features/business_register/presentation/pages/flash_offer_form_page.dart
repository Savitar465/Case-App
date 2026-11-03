import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../widgets/flash_offer_fields.dart';
import '../widgets/register_widgets.dart';

/// What [FlashOfferFormPage] pops when the owner saves.
class FlashOfferFormResult {
  const FlashOfferFormResult({required this.item, required this.offer});

  final CatalogItem item;
  final FlashOffer offer;
}

/// Creates a flash offer on one of [items], or edits one when [initialItem]
/// and [initialOffer] are given (the item is then fixed).
class FlashOfferFormPage extends StatefulWidget {
  const FlashOfferFormPage({
    super.key,
    required this.items,
    this.initialItem,
    this.initialOffer,
  });

  final List<CatalogItem> items;
  final CatalogItem? initialItem;
  final FlashOffer? initialOffer;

  @override
  State<FlashOfferFormPage> createState() => _FlashOfferFormPageState();
}

class _FlashOfferFormPageState extends State<FlashOfferFormPage> {
  late final _editor = FlashOfferEditor(initial: widget.initialOffer);
  late CatalogItem? _item = widget.initialItem;

  bool get _isEdit => widget.initialOffer != null;

  @override
  void dispose() {
    _editor.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    final item = _item;
    if (item == null) {
      _showError('Elige el producto o servicio de la oferta');
      return;
    }
    final offer = _editor.build(normalPrice: item.price, onError: _showError);
    if (offer == null) return;
    Navigator.of(context).pop(FlashOfferFormResult(item: item, offer: offer));
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    return Scaffold(
      backgroundColor: context.palette.page,
      appBar: AppBar(
        backgroundColor: context.palette.page,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            StepTitle(_isEdit ? 'Editar oferta' : 'Crear oferta flash'),
            const SizedBox(height: 10),
            const StepSubtitle(
              'Un precio especial por tiempo limitado en uno de tus '
              'productos o servicios.',
            ),
            const SizedBox(height: 24),
            const FormLabel('Producto o servicio'),
            if (_isEdit)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: context.palette.mutedFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.palette.border),
                ),
                child: Text(
                  item?.name ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            else
              DropdownButtonFormField<CatalogItem>(
                initialValue: item,
                isExpanded: true,
                hint: const Text('Elige uno'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  for (final option in widget.items)
                    DropdownMenuItem(
                      value: option,
                      child: Text(
                        '${option.name} · Bs ${formatAmount(option.price)}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _item = value),
              ),
            if (item != null) ...[
              const SizedBox(height: 8),
              Text(
                'Precio normal: Bs ${formatAmount(item.price)}',
                style: TextStyle(
                  fontSize: 13,
                  color: context.palette.textSecondary,
                ),
              ),
            ],
            FlashOfferFields(editor: _editor),
            const SizedBox(height: 32),
            WizardPrimaryButton(
              label: _isEdit ? 'Guardar cambios' : 'Crear oferta',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
