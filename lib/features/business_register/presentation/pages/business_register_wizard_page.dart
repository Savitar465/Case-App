import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/repositories/business_registration_repository.dart';
import '../bloc/business_register_cubit.dart';
import '../widgets/business_form_widgets.dart';
import '../widgets/register_widgets.dart';
import 'catalog_item_form_page.dart';

/// Hosts the multi-step business registration flow (designs img_1 → img_8),
/// sharing the progress header, navigation and a single [BusinessRegisterCubit].
class BusinessRegisterWizardPage extends StatelessWidget {
  const BusinessRegisterWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BusinessRegisterCubit(
        repository: context.read<BusinessRegistrationRepository>(),
      )..loadCategories(),
      child: const _WizardView(),
    );
  }
}

class _WizardView extends StatefulWidget {
  const _WizardView();

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _whatsapp = TextEditingController();
  final _tiktok = TextEditingController();
  final _facebook = TextEditingController();
  final _instagram = TextEditingController();
  final _website = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _whatsapp.dispose();
    _tiktok.dispose();
    _facebook.dispose();
    _instagram.dispose();
    _website.dispose();
    super.dispose();
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Salir del registro'),
        content: const Text(
          'Perderás la información que no hayas publicado. ¿Deseas salir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (shouldExit == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.page,
      body: SafeArea(
        child: BlocConsumer<BusinessRegisterCubit, BusinessRegisterState>(
          listener: (context, state) {
            if (state.status == RegisterStatus.success) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(content: Text('¡Negocio registrado!')),
                );
              Navigator.of(context).pop(true);
            } else if (state.status == RegisterStatus.failure) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error ?? 'No se pudo registrar'),
                  ),
                );
            }
          },
          builder: (context, state) {
            final isName = state.step == RegisterStep.name;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WizardTopBar(
                    onExit: _confirmExit,
                    exitLabel: isName ? 'Salir' : 'Guardar y salir',
                    progress: isName ? null : state.progress,
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: _buildStep(context, state)),
                  const SizedBox(height: 12),
                  _buildFooter(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, BusinessRegisterState state) {
    return switch (state.step) {
      RegisterStep.name => _NameStep(controller: _name),
      RegisterStep.category => const _CategoryStep(),
      RegisterStep.location => _LocationStep(controller: _address),
      RegisterStep.contact => _ContactStep(
        whatsapp: _whatsapp,
        tiktok: _tiktok,
        facebook: _facebook,
        instagram: _instagram,
        website: _website,
      ),
      RegisterStep.schedule => const _ScheduleStep(),
      RegisterStep.photos => const _PhotosStep(),
      RegisterStep.catalog => const _CatalogStep(),
    };
  }

  Widget _buildFooter(BuildContext context, BusinessRegisterState state) {
    final cubit = context.read<BusinessRegisterCubit>();

    if (state.step == RegisterStep.name) {
      return WizardPrimaryButton(
        label: 'Continuar',
        onPressed: cubit.canAdvance ? cubit.next : null,
      );
    }

    if (state.step == RegisterStep.catalog) {
      return WizardFooterNav(
        onBack: cubit.back,
        onNext: cubit.publish,
        nextLabel: 'Terminar',
        isLoading: state.isSubmitting,
      );
    }

    return WizardFooterNav(
      onBack: cubit.back,
      onNext: cubit.next,
      nextEnabled: cubit.canAdvance,
    );
  }
}

// ── Step 1: name ───────────────────────────────────────────────────────────
class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusinessRegisterCubit>();
    return ListView(
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              // Peach halo; a translucent orange keeps the glow without a
              // bright disc on the dark theme.
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFB5470B).withValues(alpha: 0.22)
                  : const Color(0xFFFBE9DD),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.storefront,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFF08A4B)
                    : const Color(0xFFB5470B),
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(child: StepTitle('¿Cómo se llama tu\nnegocio?')),
        const SizedBox(height: 12),
        const Center(
          child: StepSubtitle('Este nombre será visible para tus clientes.'),
        ),
        const SizedBox(height: 28),
        const FieldLabel('NOMBRE OFICIAL'),
        const SizedBox(height: 8),
        WizardTextField(
          controller: controller,
          hintText: 'Ej. Pollos Rodriguez',
          filled: true,
          onChanged: cubit.setName,
        ),
      ],
    );
  }
}

// ── Step 2: category ───────────────────────────────────────────────────────
class _CategoryStep extends StatelessWidget {
  const _CategoryStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusinessRegisterCubit>();
    return BlocBuilder<BusinessRegisterCubit, BusinessRegisterState>(
      builder: (context, state) {
        return ListView(
          children: [
            const StepTitle('Selecciona la categoria de\ntu negocio'),
            const SizedBox(height: 12),
            const StepSubtitle('Elige la que mejor te describa lo que ofreces'),
            const SizedBox(height: 20),
            if (state.categories.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
                children: [
                  for (final category in state.categories)
                    CategoryCard(
                      category: category,
                      selected: state.draft.category?.id == category.id,
                      onTap: () => cubit.selectCategory(category),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

// ── Step 3: location ───────────────────────────────────────────────────────
class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusinessRegisterCubit>();
    final draft = context.watch<BusinessRegisterCubit>().state.draft;
    return ListView(
      children: [
        const StepTitle('¿Dónde está tu negocio?'),
        const SizedBox(height: 10),
        const StepSubtitle(
          'Busca tu dirección o toca el mapa para colocar el pin donde estás.',
        ),
        const SizedBox(height: 16),
        BusinessLocationPicker(
          addressController: controller,
          latitude: draft.latitude,
          longitude: draft.longitude,
          onAddressChanged: cubit.setAddress,
          onLocationChanged: cubit.setLocation,
        ),
      ],
    );
  }
}

// ── Step 4: contact ────────────────────────────────────────────────────────
class _ContactStep extends StatelessWidget {
  const _ContactStep({
    required this.whatsapp,
    required this.tiktok,
    required this.facebook,
    required this.instagram,
    required this.website,
  });

  final TextEditingController whatsapp;
  final TextEditingController tiktok;
  final TextEditingController facebook;
  final TextEditingController instagram;
  final TextEditingController website;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusinessRegisterCubit>();
    return ListView(
      children: [
        const StepTitle('¿Cómo te pueden contactar\nlos clientes?'),
        const SizedBox(height: 12),
        const StepSubtitle('Agrega tus canales de comunicación.'),
        const SizedBox(height: 16),
        Row(
          children: [
            const SocialBadge(color: Color(0xFF25D366), icon: Icons.chat),
            const SizedBox(width: 10),
            const Text(
              'WhatsApp',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const CountryCodeBox(code: '+591'),
            const SizedBox(width: 10),
            Expanded(
              child: WizardTextField(
                controller: whatsapp,
                keyboardType: TextInputType.phone,
                onChanged: cubit.setWhatsapp,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Redes sociales y página web (opcional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        SocialField(
          label: 'TikTok',
          badge: const SocialBadge(
            color: Color(0xFF111111),
            icon: Icons.music_note,
          ),
          controller: tiktok,
          onChanged: cubit.setTiktok,
        ),
        SocialField(
          label: 'Facebook',
          badge: const SocialBadge(
            color: Color(0xFF1877F2),
            icon: Icons.facebook,
          ),
          controller: facebook,
          onChanged: cubit.setFacebook,
        ),
        SocialField(
          label: 'Instagram',
          badge: const SocialBadge(
            color: Color(0xFFE1306C),
            icon: Icons.camera_alt,
          ),
          controller: instagram,
          onChanged: cubit.setInstagram,
        ),
        SocialField(
          label: 'Página web',
          badge: const SocialBadge(
            color: Color(0xFF1A73E8),
            icon: Icons.public,
          ),
          controller: website,
          onChanged: cubit.setWebsite,
        ),
      ],
    );
  }
}

// ── Step 5: schedule ───────────────────────────────────────────────────────
class _ScheduleStep extends StatelessWidget {
  const _ScheduleStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusinessRegisterCubit>();
    return BlocBuilder<BusinessRegisterCubit, BusinessRegisterState>(
      builder: (context, state) {
        final schedule = state.draft.schedule;
        return ListView(
          children: [
            const StepTitle('Horario de atención'),
            const SizedBox(height: 20),
            for (var i = 0; i < schedule.length; i++) ...[
              DayScheduleCard(
                day: schedule[i],
                onChanged: (day) => cubit.setDay(i, day),
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

// ── Step 6: photos ─────────────────────────────────────────────────────────
class _PhotosStep extends StatelessWidget {
  const _PhotosStep();

  Future<void> _pickPhotos(BuildContext context) async {
    final cubit = context.read<BusinessRegisterCubit>();
    try {
      final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
      if (picked.isEmpty) return;
      cubit.addPhotos(picked.map((image) => image.path).toList());
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
    return BlocBuilder<BusinessRegisterCubit, BusinessRegisterState>(
      builder: (context, state) {
        final photos = state.draft.photos;
        return ListView(
          children: [
            const StepTitle('¿Quieres agregar fotos de tu\nnegocio?'),
            const SizedBox(height: 16),
            const StepSubtitle(
              'Las fotos de tu negocio ayudan a los clientes a conocer mejor y '
              'generan mayor confianza de tus productos o servicios.',
            ),
            const SizedBox(height: 24),
            if (photos.isEmpty)
              _PhotoDropzone(onTap: () => _pickPhotos(context))
            else
              _PhotoGrid(
                photos: photos,
                onAdd: () => _pickPhotos(context),
                onRemove: context.read<BusinessRegisterCubit>().removePhoto,
              ),
          ],
        );
      },
    );
  }
}

/// Large empty-state tile shown before any photo is picked.
class _PhotoDropzone extends StatelessWidget {
  const _PhotoDropzone({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.palette.textMuted),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 56),
            SizedBox(height: 16),
            Text(
              'Toca para subir tus fotos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thumbnail grid of picked photos with an add tile and per-photo remove.
class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> photos;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        for (final path in photos)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(path), fit: BoxFit.cover),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemove(path),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        InkWell(
          onTap: onAdd,
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

// ── Step 7: catalog + done ─────────────────────────────────────────────────
class _CatalogStep extends StatelessWidget {
  const _CatalogStep();

  Future<void> _addItem(BuildContext context, CatalogItemKind kind) async {
    final cubit = context.read<BusinessRegisterCubit>();
    final item = await Navigator.of(context).push<CatalogItemDraft>(
      MaterialPageRoute(builder: (_) => CatalogItemFormPage(kind: kind)),
    );
    if (item != null) cubit.addCatalogItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessRegisterCubit, BusinessRegisterState>(
      builder: (context, state) {
        final services = state.draft.services.length;
        final products = state.draft.products.length;
        return ListView(
          children: [
            _AddRow(
              label: 'Agrega servicios',
              count: services,
              onTap: () => _addItem(context, CatalogItemKind.service),
            ),
            const SizedBox(height: 20),
            _AddRow(
              label: 'Agrega productos',
              count: products,
              onTap: () => _addItem(context, CatalogItemKind.product),
            ),
            const SizedBox(height: 40),
            const Center(child: Text('🎉', style: TextStyle(fontSize: 72))),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '¡Listo!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Tu negocio ya está\nlisto para publicar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, height: 1.2),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow({
    required this.label,
    required this.count,
    required this.onTap,
  });

  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.add, size: 34),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                count == 0 ? label : '$label ($count)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: context.palette.textMuted),
          ],
        ),
      ),
    );
  }
}
