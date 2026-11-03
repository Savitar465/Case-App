import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../market/domain/entities/category.dart';
import '../../domain/entities/business_draft.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/entities/editable_photo.dart';
import '../../domain/repositories/business_registration_repository.dart';
import '../bloc/edit_business_cubit.dart';
import '../widgets/business_form_widgets.dart';
import '../widgets/register_widgets.dart';

export '../bloc/edit_business_cubit.dart' show EditBusinessSection;

/// Edits one [section] of an owned business (one screen per dashboard
/// option). Pops `true` once saved.
class EditBusinessPage extends StatelessWidget {
  const EditBusinessPage({
    super.key,
    required this.businessId,
    required this.section,
  });

  static const routeName = '/business/edit';

  final String businessId;
  final EditBusinessSection section;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditBusinessCubit(
        repository: context.read<BusinessRegistrationRepository>(),
        businessId: businessId,
        section: section,
      )..load(),
      child: const _EditBusinessView(),
    );
  }
}

class _EditBusinessView extends StatelessWidget {
  const _EditBusinessView();

  static String _titleFor(EditBusinessSection section) => switch (section) {
    EditBusinessSection.info => 'Editar información',
    EditBusinessSection.photos => 'Fotos del negocio',
    EditBusinessSection.schedule => 'Horario',
    EditBusinessSection.social => 'Redes sociales y web',
  };

  Future<void> _confirmDiscard(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Descartar cambios'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Deseas salir sin guardarlos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Seguir editando'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
    if (discard == true && context.mounted) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditBusinessCubit, EditBusinessState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.error != current.error,
      listener: (context, state) {
        if (state.status == EditBusinessStatus.saved) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('Cambios guardados')));
          Navigator.of(context).pop(true);
        } else if (state.status == EditBusinessStatus.ready &&
            state.error != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        final canLeave =
            !state.isDirty ||
            state.status == EditBusinessStatus.saved ||
            state.status == EditBusinessStatus.loadFailure;
        return PopScope<bool>(
          canPop: canLeave,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && !state.isSaving) _confirmDiscard(context);
          },
          child: Scaffold(
            backgroundColor: context.palette.page,
            appBar: AppBar(
              backgroundColor: context.palette.page,
              surfaceTintColor: context.palette.page,
              foregroundColor: context.palette.textPrimary,
              centerTitle: true,
              title: Text(
                _titleFor(state.section),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: switch (state.status) {
              EditBusinessStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              EditBusinessStatus.loadFailure => _LoadError(
                message: state.error ?? 'No se pudo cargar el negocio',
                onRetry: context.read<EditBusinessCubit>().load,
              ),
              _ => switch (state.section) {
                EditBusinessSection.info => const _InfoSection(),
                EditBusinessSection.photos => const _PhotosSection(),
                EditBusinessSection.schedule => const _ScheduleSection(),
                EditBusinessSection.social => const _SocialSection(),
              },
            },
            bottomNavigationBar: state.draft == null
                ? null
                : _SaveBar(state: state),
          ),
        );
      },
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state});

  final EditBusinessState state;

  @override
  Widget build(BuildContext context) {
    final hint = state.isDirty ? state.validationError : null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hint != null) ...[
              Text(
                hint,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
              const SizedBox(height: 8),
            ],
            WizardPrimaryButton(
              label: 'Guardar cambios',
              isLoading: state.isSaving,
              onPressed: state.canSave
                  ? context.read<EditBusinessCubit>().save
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}

/// Padding + muted subtitle shared by every section screen.
class _SectionBody extends StatelessWidget {
  const _SectionBody({required this.subtitle, required this.children});

  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        StepSubtitle(subtitle),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }
}

/// Reads the loaded draft once, to seed text controllers.
BusinessDraft _loadedDraft(BuildContext context) =>
    context.read<EditBusinessCubit>().state.draft!;

// ── Editar información ───────────────────────────────────────────────────
class _InfoSection extends StatefulWidget {
  const _InfoSection();

  @override
  State<_InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<_InfoSection> {
  late final BusinessDraft _initial = _loadedDraft(context);
  late final _name = TextEditingController(text: _initial.name);
  late final _description = TextEditingController(text: _initial.description);
  late final _address = TextEditingController(text: _initial.address);
  late final _whatsapp = TextEditingController(text: _initial.whatsapp);
  late final _phone = TextEditingController(text: _initial.phone);
  late final _email = TextEditingController(text: _initial.email);

  @override
  void dispose() {
    for (final controller in [
      _name,
      _description,
      _address,
      _whatsapp,
      _phone,
      _email,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditBusinessCubit>();
    final state = context.watch<EditBusinessCubit>().state;
    final draft = state.draft!;
    void edit(BusinessDraft Function(BusinessDraft) change) =>
        cubit.editDraft(change);

    return _SectionBody(
      subtitle: 'Datos principales, ubicación y contacto de tu negocio.',
      children: [
        const FieldLabel('NOMBRE'),
        const SizedBox(height: 8),
        WizardTextField(
          controller: _name,
          hintText: 'Ej. Pollos Rodriguez',
          onChanged: (v) => edit((d) => d.copyWith(name: v)),
        ),
        const SizedBox(height: 16),
        const FieldLabel('DESCRIPCIÓN (OPCIONAL)'),
        const SizedBox(height: 8),
        WizardTextField(
          controller: _description,
          hintText: 'Cuéntales a tus clientes qué ofreces',
          maxLines: 4,
          onChanged: (v) => edit((d) => d.copyWith(description: v)),
        ),
        const SizedBox(height: 16),
        const FieldLabel('CATEGORÍA'),
        const SizedBox(height: 8),
        _CategoryPicker(state: state, onSelect: cubit.selectCategory),
        const SizedBox(height: 24),
        const FieldLabel('UBICACIÓN'),
        const SizedBox(height: 8),
        BusinessLocationPicker(
          addressController: _address,
          latitude: draft.latitude,
          longitude: draft.longitude,
          onAddressChanged: (v) => edit((d) => d.copyWith(address: v)),
          onLocationChanged: cubit.setLocation,
        ),
        const SizedBox(height: 24),
        const FieldLabel('CONTACTO'),
        const SizedBox(height: 8),
        Row(
          children: [
            CountryCodeBox(code: draft.whatsappCountryCode),
            const SizedBox(width: 10),
            Expanded(
              child: WizardTextField(
                controller: _whatsapp,
                hintText: 'WhatsApp',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.chat, color: Color(0xFF25D366)),
                onChanged: (v) => edit((d) => d.copyWith(whatsapp: v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        WizardTextField(
          controller: _phone,
          hintText: 'Teléfono (opcional)',
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(Icons.phone, color: context.palette.textTertiary),
          onChanged: (v) => edit((d) => d.copyWith(phone: v)),
        ),
        const SizedBox(height: 12),
        WizardTextField(
          controller: _email,
          hintText: 'Correo electrónico (opcional)',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.mail_outline,
            color: context.palette.textTertiary,
          ),
          onChanged: (v) => edit((d) => d.copyWith(email: v)),
        ),
      ],
    );
  }
}

// ── Fotos del negocio ────────────────────────────────────────────────────
class _PhotosSection extends StatelessWidget {
  const _PhotosSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditBusinessCubit>();
    final photos = context.select<EditBusinessCubit, List<EditablePhoto>>(
      (cubit) => cubit.state.photos,
    );
    return _SectionBody(
      subtitle:
          'La primera foto es la portada. Toca la estrella para elegir otra '
          'portada o la X para quitar una foto.',
      children: [
        _PhotoEditor(
          photos: photos,
          onAdd: cubit.addPhotos,
          onRemove: cubit.removePhoto,
          onMakeCover: cubit.makeCover,
        ),
      ],
    );
  }
}

// ── Horario ──────────────────────────────────────────────────────────────
class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditBusinessCubit>();
    final schedule = context.select<EditBusinessCubit, List<DaySchedule>>(
      (cubit) => cubit.state.draft!.schedule,
    );
    return _SectionBody(
      subtitle:
          'Indica los días y horas en que atiendes. Si cierras a mediodía, '
          'usa "Agregar turno" para cada horario.',
      children: [
        for (var i = 0; i < schedule.length; i++) ...[
          DayScheduleCard(
            day: schedule[i],
            onChanged: (day) => cubit.updateDay(i, (_) => day),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

// ── Redes sociales y página web ──────────────────────────────────────────
class _SocialSection extends StatefulWidget {
  const _SocialSection();

  @override
  State<_SocialSection> createState() => _SocialSectionState();
}

class _SocialSectionState extends State<_SocialSection> {
  late final BusinessDraft _initial = _loadedDraft(context);
  late final _tiktok = TextEditingController(text: _initial.tiktok);
  late final _facebook = TextEditingController(text: _initial.facebook);
  late final _instagram = TextEditingController(text: _initial.instagram);
  late final _website = TextEditingController(text: _initial.website);

  @override
  void dispose() {
    for (final controller in [_tiktok, _facebook, _instagram, _website]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditBusinessCubit>();
    void edit(BusinessDraft Function(BusinessDraft) change) =>
        cubit.editDraft(change);

    return _SectionBody(
      subtitle: 'Deja vacío lo que no uses; no se mostrará en tu perfil.',
      children: [
        SocialField(
          label: 'TikTok',
          badge: const SocialBadge(
            color: Color(0xFF111111),
            icon: Icons.music_note,
          ),
          controller: _tiktok,
          onChanged: (v) => edit((d) => d.copyWith(tiktok: v)),
        ),
        SocialField(
          label: 'Facebook',
          badge: const SocialBadge(
            color: Color(0xFF1877F2),
            icon: Icons.facebook,
          ),
          controller: _facebook,
          onChanged: (v) => edit((d) => d.copyWith(facebook: v)),
        ),
        SocialField(
          label: 'Instagram',
          badge: const SocialBadge(
            color: Color(0xFFE1306C),
            icon: Icons.camera_alt,
          ),
          controller: _instagram,
          onChanged: (v) => edit((d) => d.copyWith(instagram: v)),
        ),
        SocialField(
          label: 'Página web',
          badge: const SocialBadge(
            color: Color(0xFF1A73E8),
            icon: Icons.public,
          ),
          controller: _website,
          keyboardType: TextInputType.url,
          onChanged: (v) => edit((d) => d.copyWith(website: v)),
        ),
      ],
    );
  }
}

/// Horizontal strip of category cards. Falls back to the current category
/// alone when the category list could not be loaded.
class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.state, required this.onSelect});

  final EditBusinessState state;
  final ValueChanged<MarketCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    final selected = state.draft?.category;
    final categories = state.categories.isNotEmpty
        ? state.categories
        : [?selected];
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          return SizedBox(
            width: 120,
            child: CategoryCard(
              category: category,
              selected: selected?.id == category.id,
              onTap: () => onSelect(category),
            ),
          );
        },
      ),
    );
  }
}

/// Grid of current photos (remote or freshly picked). The first is the cover;
/// the star moves another photo to the front.
class _PhotoEditor extends StatelessWidget {
  const _PhotoEditor({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    required this.onMakeCover,
  });

  final List<EditablePhoto> photos;
  final ValueChanged<List<String>> onAdd;
  final ValueChanged<EditablePhoto> onRemove;
  final ValueChanged<EditablePhoto> onMakeCover;

  Future<void> _pick(BuildContext context) async {
    try {
      final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
      if (picked.isNotEmpty) onAdd(picked.map((image) => image.path).toList());
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('No se pudieron abrir las fotos.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        for (var i = 0; i < photos.length; i++)
          _PhotoTile(
            photo: photos[i],
            isCover: i == 0,
            onRemove: () => onRemove(photos[i]),
            onMakeCover: () => onMakeCover(photos[i]),
          ),
        InkWell(
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.palette.textMuted),
            ),
            child: const Icon(Icons.add_a_photo_outlined, size: 32),
          ),
        ),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.isCover,
    required this.onRemove,
    required this.onMakeCover,
  });

  final EditablePhoto photo;
  final bool isCover;
  final VoidCallback onRemove;
  final VoidCallback onMakeCover;

  @override
  Widget build(BuildContext context) {
    final localPath = photo.localPath;
    final image = localPath != null
        ? Image.file(File(localPath), fit: BoxFit.cover)
        : Image.network(
            photo.url!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => ColoredBox(
              color: context.palette.mutedFill,
              child: const Icon(Icons.broken_image_outlined),
            ),
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          Positioned(
            top: 4,
            right: 4,
            child: _RoundIcon(
              icon: Icons.close,
              tooltip: 'Quitar foto',
              onTap: onRemove,
            ),
          ),
          if (isCover)
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Portada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            Positioned(
              top: 4,
              left: 4,
              child: _RoundIcon(
                icon: Icons.star_border,
                tooltip: 'Usar como portada',
                onTap: onMakeCover,
              ),
            ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Colors.black54,
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}
