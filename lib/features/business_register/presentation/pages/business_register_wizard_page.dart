import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/static_location_map.dart';
import '../../../market/domain/entities/category.dart';
import '../../domain/entities/catalog_item_draft.dart';
import '../../domain/repositories/business_registration_repository.dart';
import '../bloc/business_register_cubit.dart';
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
      backgroundColor: Colors.white,
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
            decoration: const BoxDecoration(
              color: Color(0xFFFBE9DD),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.storefront,
                color: Color(0xFFB5470B),
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
                    _CategoryCard(
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final MarketCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.purple : Colors.black87;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.purpleSurface : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.purple : const Color(0xFFCFC4C9),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_iconFor(category.icon), color: color, size: 40),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                category.nameEs,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String? iconHex) {
    if (iconHex == null || iconHex.isEmpty) return Icons.storefront;
    try {
      final clean = iconHex.startsWith('0x') ? iconHex.substring(2) : iconHex;
      // Code point is parsed at runtime, so it can't be const.
      // ignore: non_const_argument_for_const_parameter
      return IconData(int.parse(clean, radix: 16), fontFamily: 'MaterialIcons');
    } catch (_) {
      return Icons.storefront;
    }
  }
}

// ── Step 3: location ───────────────────────────────────────────────────────
class _LocationStep extends StatefulWidget {
  const _LocationStep({required this.controller});

  final TextEditingController controller;

  @override
  State<_LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<_LocationStep> {
  /// Fallback camera target when no point is chosen yet: Santa Cruz de la
  /// Sierra, Bolivia (matches the default +591 country code).
  static const LatLng _fallbackCenter = LatLng(-17.7834, -63.1821);

  final MapController _mapController = MapController();
  bool _locating = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Persists a chosen coordinate and reverse-geocodes it into the address
  /// field so the user sees a human-readable location.
  Future<void> _selectPoint(LatLng point, {bool recenter = false}) async {
    final cubit = context.read<BusinessRegisterCubit>();
    cubit.setLocation(point.latitude, point.longitude);
    if (recenter) _mapController.move(point, 16);

    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (!mounted || placemarks.isEmpty) return;
      final address = _formatPlacemark(placemarks.first);
      if (address.isEmpty) return;
      widget.controller.text = address;
      cubit.setAddress(address);
    } catch (_) {
      // Reverse geocoding is best-effort; the pin is already saved.
    }
  }

  Future<void> _useCurrentLocation() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showMessage('Activa la ubicación del dispositivo para continuar.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Necesitamos permiso de ubicación para localizarte.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      await _selectPoint(
        LatLng(position.latitude, position.longitude),
        recenter: true,
      );
    } catch (_) {
      _showMessage('No pudimos obtener tu ubicación. Inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _searchAddress(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    try {
      final results = await locationFromAddress(trimmed);
      if (!mounted || results.isEmpty) {
        if (mounted) _showMessage('No encontramos esa dirección.');
        return;
      }
      final match = results.first;
      final point = LatLng(match.latitude, match.longitude);
      context.read<BusinessRegisterCubit>().setLocation(
        point.latitude,
        point.longitude,
      );
      _mapController.move(point, 16);
    } catch (_) {
      if (mounted) _showMessage('No encontramos esa dirección.');
    }
  }

  String _formatPlacemark(Placemark p) {
    final parts = <String?>[
      p.street,
      p.subLocality,
      p.locality,
    ].where((part) => part != null && part.trim().isNotEmpty).cast<String>();
    return parts.join(', ');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusinessRegisterCubit>();
    final draft = context.watch<BusinessRegisterCubit>().state.draft;
    final point = (draft.latitude != null && draft.longitude != null)
        ? LatLng(draft.latitude!, draft.longitude!)
        : null;

    return ListView(
      children: [
        const StepTitle('¿Dónde está tu negocio?'),
        const SizedBox(height: 10),
        const StepSubtitle(
          'Busca tu dirección o toca el mapa para colocar el pin donde estás.',
        ),
        const SizedBox(height: 16),
        WizardTextField(
          controller: widget.controller,
          hintText: 'Buscar dirección o zona',
          prefixIcon: const Icon(Icons.search, color: Colors.black45),
          textInputAction: TextInputAction.search,
          onChanged: cubit.setAddress,
          onSubmitted: _searchAddress,
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 240,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: point ?? _fallbackCenter,
                initialZoom: point != null ? 16 : 12,
                onTap: (_, tapped) => _selectPoint(tapped),
              ),
              children: [
                TileLayer(
                  urlTemplate: kOsmTileUrl,
                  userAgentPackageName: kMapUserAgent,
                ),
                if (point != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 44,
                        height: 44,
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 44,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _locating ? null : _useCurrentLocation,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black54,
            side: const BorderSide(color: Color(0xFFE0E0E0)),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          icon: _locating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.purple,
                  ),
                )
              : const Icon(Icons.my_location, color: AppColors.purple),
          label: Text(
            _locating ? 'Obteniendo ubicación…' : 'Usar mi ubicación actual',
          ),
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
            _socialBadge(const Color(0xFF25D366), Icons.chat),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kFieldBorder),
              ),
              child: const Text(
                '+591',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
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
        _SocialField(
          label: 'TikTok',
          badge: _socialBadge(const Color(0xFF111111), Icons.music_note),
          controller: tiktok,
          onChanged: cubit.setTiktok,
        ),
        _SocialField(
          label: 'Facebook',
          badge: _socialBadge(const Color(0xFF1877F2), Icons.facebook),
          controller: facebook,
          onChanged: cubit.setFacebook,
        ),
        _SocialField(
          label: 'Instagram',
          badge: _socialBadge(const Color(0xFFE1306C), Icons.camera_alt),
          controller: instagram,
          onChanged: cubit.setInstagram,
        ),
        _SocialField(
          label: 'Página web',
          badge: _socialBadge(const Color(0xFF1A73E8), Icons.public),
          controller: website,
          onChanged: cubit.setWebsite,
        ),
      ],
    );
  }

  Widget _socialBadge(Color color, IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

class _SocialField extends StatelessWidget {
  const _SocialField({
    required this.label,
    required this.badge,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final Widget badge;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          Row(
            children: [
              badge,
              const SizedBox(width: 12),
              Expanded(
                child: WizardTextField(
                  controller: controller,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
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
              _DayCard(
                index: i,
                day: schedule[i],
                onToggle: (v) => cubit.toggleDay(i, v),
                onOpen: (v) => cubit.setDayOpen(i, v),
                onClose: (v) => cubit.setDayClose(i, v),
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.index,
    required this.day,
    required this.onToggle,
    required this.onOpen,
    required this.onClose,
  });

  final int index;
  final dynamic day; // DaySchedule
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onClose;

  Future<void> _pickTime(
    BuildContext context,
    String current,
    ValueChanged<String> onPicked,
  ) async {
    final parts = current.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 8,
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      onPicked('${picked.hour}:${picked.minute.toString().padLeft(2, '0')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = day.isOpen as bool;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black26),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day.label as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                isOpen ? 'Abierto' : 'Cerrado',
                style: TextStyle(
                  color: isOpen ? const Color(0xFF22C55E) : Colors.black45,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isOpen,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF3B7A2A),
                onChanged: onToggle,
              ),
            ],
          ),
          if (isOpen) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                _TimeText(
                  value: day.open as String,
                  onTap: () => _pickTime(context, day.open as String, onOpen),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('-', style: TextStyle(fontSize: 22)),
                ),
                _TimeText(
                  value: day.close as String,
                  onTap: () => _pickTime(context, day.close as String, onClose),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeText extends StatelessWidget {
  const _TimeText({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.black54,
          decoration: TextDecoration.underline,
        ),
      ),
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
          border: Border.all(color: Colors.black38),
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
              border: Border.all(color: Colors.black38),
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
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
