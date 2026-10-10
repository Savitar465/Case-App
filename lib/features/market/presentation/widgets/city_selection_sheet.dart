import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/core/theme/app_colors.dart';
import 'package:market_app/core/theme/app_palette.dart';
import 'package:market_app/features/market/presentation/bloc/market_cubit.dart';

class MarketCity {
  const MarketCity({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

const List<MarketCity> kAvailableCities = [
  MarketCity(name: 'La Paz', latitude: -16.5000, longitude: -68.1500),
  MarketCity(name: 'Pando', latitude: -11.0267, longitude: -68.7692),
  MarketCity(name: 'El Alto', latitude: -16.5042, longitude: -68.1633),
  MarketCity(name: 'Santa Cruz', latitude: -17.7833, longitude: -63.1821),
  MarketCity(name: 'Cochabamba', latitude: -17.3895, longitude: -66.1568),
  MarketCity(name: 'Oruro', latitude: -17.9833, longitude: -67.1500),
  MarketCity(name: 'Potosí', latitude: -19.5836, longitude: -65.7531),
  MarketCity(name: 'Sucre', latitude: -19.0333, longitude: -65.2627),
  MarketCity(name: 'Tarija', latitude: -21.5355, longitude: -64.7296),
  MarketCity(name: 'Beni', latitude: -14.8333, longitude: -64.9000),
];

/// Shows the "Seleccionar ciudad" bottom sheet modal.
Future<void> showCitySelectionSheet({
  required BuildContext context,
  required VoidCallback onUseCurrentLocation,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: context.read<MarketCubit>(),
      child: CitySelectionSheet(onUseCurrentLocation: onUseCurrentLocation),
    ),
  );
}

class CitySelectionSheet extends StatelessWidget {
  const CitySelectionSheet({super.key, required this.onUseCurrentLocation});

  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final currentLabel = context.select(
      (MarketCubit c) => c.state.locationLabel,
    );
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: palette.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.faint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SheetHeader(onClose: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              _CurrentLocationCard(
                onTap: () {
                  Navigator.of(context).pop();
                  onUseCurrentLocation();
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Ciudades disponibles',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              for (final city in kAvailableCities)
                _CityTile(
                  city: city,
                  isSelected:
                      currentLabel.trim().toLowerCase() ==
                      city.name.toLowerCase(),
                  onTap: () {
                    context.read<MarketCubit>().setUserLocation(
                          latitude: city.latitude,
                          longitude: city.longitude,
                          label: city.name,
                          isManual: true,
                        );
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccionar ciudad',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Elige la ciudad donde quieres buscar negocios locales.',
                style: TextStyle(
                  fontSize: 14,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: palette.mutedFill,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                size: 20,
                color: palette.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentLocationCard extends StatelessWidget {
  const _CurrentLocationCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: palette.mutedFill,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.neutralBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: palette.purpleSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: AppColors.purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usar mi ubicación actual',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Detectar tu ciudad automáticamente',
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.city,
    required this.isSelected,
    required this.onTap,
  });

  final MarketCity city;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? palette.purpleSurface : palette.mutedFill,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.purple : palette.neutralBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.purple
                        : palette.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 20,
                    color: isSelected ? Colors.white : palette.textTertiary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    city.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? palette.textPrimary
                          : palette.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  )
                else
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: palette.neutralBorder,
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
