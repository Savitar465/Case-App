import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/static_location_map.dart';
import '../../../market/domain/entities/category.dart';
import '../../domain/entities/day_schedule.dart';
import 'register_widgets.dart';

/// Business form pieces shared by the registration wizard and the edit page.
/// They are cubit-agnostic: callers pass values in and get changes back.

// ── Category ─────────────────────────────────────────────────────────────
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final MarketCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.purple : context.palette.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? context.palette.purpleSurface
              : context.palette.mutedFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.purple : context.palette.neutralBorder,
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

// ── Contact / social ─────────────────────────────────────────────────────
class SocialBadge extends StatelessWidget {
  const SocialBadge({super.key, required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
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

class SocialField extends StatelessWidget {
  const SocialField({
    super.key,
    required this.label,
    required this.badge,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
  });

  final String label;
  final Widget badge;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

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
                  keyboardType: keyboardType,
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

/// The fixed "+591" prefix box shown before the WhatsApp number.
class CountryCodeBox extends StatelessWidget {
  const CountryCodeBox({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.border),
      ),
      child: Text(code, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

// ── Schedule ─────────────────────────────────────────────────────────────
/// One weekday: open/closed switch plus one row per shift ("turno"), with
/// "Agregar turno" for split schedules. Reports the whole updated day.
class DayScheduleCard extends StatelessWidget {
  const DayScheduleCard({
    super.key,
    required this.day,
    required this.onChanged,
  });

  final DaySchedule day;
  final ValueChanged<DaySchedule> onChanged;

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
    final isOpen = day.isOpen;
    final error = day.validationError;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.faint),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day.label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                isOpen ? 'Abierto' : 'Cerrado',
                style: TextStyle(
                  color: isOpen
                      ? const Color(0xFF22C55E)
                      : context.palette.textTertiary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isOpen,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF3B7A2A),
                onChanged: (value) => onChanged(day.copyWith(isOpen: value)),
              ),
            ],
          ),
          if (isOpen) ...[
            for (var i = 0; i < day.ranges.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    _TimeText(
                      value: day.ranges[i].open,
                      onTap: () => _pickTime(
                        context,
                        day.ranges[i].open,
                        (v) => onChanged(
                          day.updateRange(i, day.ranges[i].copyWith(open: v)),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('-', style: TextStyle(fontSize: 22)),
                    ),
                    _TimeText(
                      value: day.ranges[i].close,
                      onTap: () => _pickTime(
                        context,
                        day.ranges[i].close,
                        (v) => onChanged(
                          day.updateRange(i, day.ranges[i].copyWith(close: v)),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (day.ranges.length > 1)
                      IconButton(
                        tooltip: 'Quitar turno',
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: context.palette.textTertiary,
                        ),
                        onPressed: () => onChanged(day.removeRange(i)),
                      ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => onChanged(day.addRange()),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.purple,
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar turno'),
              ),
            ),
            if (error != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
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
        style: TextStyle(
          fontSize: 22,
          color: context.palette.textSecondary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

// ── Location ─────────────────────────────────────────────────────────────
/// Address search field + tappable map + "use my location" button.
class BusinessLocationPicker extends StatefulWidget {
  const BusinessLocationPicker({
    super.key,
    required this.addressController,
    required this.latitude,
    required this.longitude,
    required this.onAddressChanged,
    required this.onLocationChanged,
  });

  final TextEditingController addressController;
  final double? latitude;
  final double? longitude;
  final ValueChanged<String> onAddressChanged;
  final void Function(double latitude, double longitude) onLocationChanged;

  @override
  State<BusinessLocationPicker> createState() => _BusinessLocationPickerState();
}

class _BusinessLocationPickerState extends State<BusinessLocationPicker> {
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
    widget.onLocationChanged(point.latitude, point.longitude);
    if (recenter) _mapController.move(point, 16);

    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (!mounted || placemarks.isEmpty) return;
      final address = _formatPlacemark(placemarks.first);
      if (address.isEmpty) return;
      widget.addressController.text = address;
      widget.onAddressChanged(address);
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
      widget.onLocationChanged(point.latitude, point.longitude);
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
    final point = (widget.latitude != null && widget.longitude != null)
        ? LatLng(widget.latitude!, widget.longitude!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WizardTextField(
          controller: widget.addressController,
          hintText: 'Buscar dirección o zona',
          prefixIcon: Icon(Icons.search, color: context.palette.textTertiary),
          textInputAction: TextInputAction.search,
          onChanged: widget.onAddressChanged,
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
            foregroundColor: context.palette.textSecondary,
            side: BorderSide(color: context.palette.neutralBorder),
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
