import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../widgets/flash_offer_fields.dart';
import '../widgets/register_widgets.dart';

/// Form to add a single service or product, or edit one when [initial] is
/// given. Returns a [CatalogItemDraft] via [Navigator.pop].
///
/// In edit mode the offer-type choice is hidden (offers are managed from
/// "Ofertas activas") and the draft keeps [initial]'s id; a new photo comes
/// back in [CatalogItemDraft.photoPath], a removed one as
/// [CatalogItemDraft.clearPhoto].
class CatalogItemFormPage extends StatefulWidget {
  const CatalogItemFormPage({super.key, required this.kind, this.initial});

  final CatalogItemKind kind;
  final CatalogItem? initial;

  @override
  State<CatalogItemFormPage> createState() => _CatalogItemFormPageState();
}

class _CatalogItemFormPageState extends State<CatalogItemFormPage> {
  static const _uuid = Uuid();

  late final CatalogItem? _initial = widget.initial;

  bool get _isEdit => _initial != null;

  late final _nameController = TextEditingController(text: _initial?.name);
  late final _priceController = TextEditingController(
    text: _initial == null ? null : formatAmount(_initial.price),
  );
  late final _quantityController = TextEditingController(
    text: _initial?.stock?.toString(),
  );
  late final _descriptionController = TextEditingController(
    text: _initial?.description,
  );
  final _flashEditor = FlashOfferEditor();

  OfferType _offerType = OfferType.none;

  /// Newly picked local photo.
  String? _photoPath;

  /// The stored photo was removed in this session (edit mode).
  bool _clearedPhoto = false;

  String? get _remotePhotoUrl => _clearedPhoto ? null : _initial?.photoUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _flashEditor.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
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

  void _removePhoto() {
    setState(() {
      if (_photoPath != null) {
        _photoPath = null;
      } else {
        _clearedPhoto = true;
      }
    });
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
      flashOffer = _flashEditor.build(normalPrice: price, onError: _showError);
      if (flashOffer == null) return;
    }

    final item = CatalogItemDraft(
      id: _initial?.id ?? _uuid.v4(),
      kind: widget.kind,
      name: name,
      price: price,
      offerType: _offerType,
      flashOffer: flashOffer,
      quantity: int.tryParse(_quantityController.text),
      description: description.isEmpty ? null : description,
      photoPath: _photoPath,
      clearPhoto: _clearedPhoto && _photoPath == null,
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
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
          children: _fields(),
        ),
      ),
    );
  }

  List<Widget> _fields() {
    final isFlash = _offerType == OfferType.flash;
    return [
      StepTitle(_isEdit ? 'Editar ${widget.kind.singular}' : widget.kind.title),
      const SizedBox(height: 20),
      const FormLabel('Nombre'),
      WizardTextField(
        controller: _nameController,
        hintText: widget.kind.nameHint,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 24),
      const FormLabel('Precio normal'),
      PriceStepper(controller: _priceController),
      if (!_isEdit) ...[
        const SizedBox(height: 24),
        const FormLabel('Tipo de oferta'),
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
              ? FlashOfferFields(editor: _flashEditor)
              : const SizedBox(width: double.infinity),
        ),
      ],
      const SizedBox(height: 24),
      const FormLabel('Cantidad disponible'),
      PriceStepper(
        controller: _quantityController,
        prefixText: null,
        integerOnly: true,
      ),
      const SizedBox(height: 6),
      Text(
        'Déjalo vacío si no deseas establecer una cantidad',
        style: TextStyle(fontSize: 12, color: context.palette.textSecondary),
      ),
      const SizedBox(height: 24),
      const FormLabel('Descripción (opcional)'),
      WizardTextField(controller: _descriptionController, maxLines: 3),
      const SizedBox(height: 24),
      FormLabel(_isEdit ? 'Foto (opcional)' : 'Añadir foto (opcional)'),
      _PhotoBox(
        photoPath: _photoPath,
        photoUrl: _remotePhotoUrl,
        onTap: _pickPhoto,
        onRemove: _removePhoto,
      ),
      const SizedBox(height: 32),
      WizardPrimaryButton(
        label: _isEdit ? 'Guardar cambios' : 'Agregar ${widget.kind.singular}',
        onPressed: _submit,
      ),
    ];
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
      color: selected ? context.palette.purpleSurface : context.palette.surface,
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
              color: selected ? AppColors.purple : context.palette.border,
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
                    color: selected
                        ? AppColors.purple
                        : context.palette.textMuted,
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
                  style: TextStyle(
                    fontSize: 12,
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Photo dropzone; shows a preview of the picked photo, or of the stored one
/// ([photoUrl]) when editing.
class _PhotoBox extends StatelessWidget {
  const _PhotoBox({
    required this.photoPath,
    required this.onTap,
    required this.onRemove,
    this.photoUrl,
  });

  final String? photoPath;
  final String? photoUrl;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final url = photoUrl;
    if (path != null || url != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: path != null
                ? Image.file(
                    File(path),
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    url!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => SizedBox(
                      height: 160,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: context.palette.textMuted,
                      ),
                    ),
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
          border: Border.all(color: context.palette.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 44),
            SizedBox(height: 6),
            Text(
              'Toca para elegir una foto',
              style: TextStyle(
                fontSize: 13,
                color: context.palette.textSecondary,
              ),
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
