import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../bloc/offers_feed_cubit.dart';

/// "Filtros | Vencimiento · Descuento · Negocio" chip row.
class OffersFilterBar extends StatelessWidget {
  const OffersFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OffersFeedCubit>().state;
    final businessCount = state.businessIds.length;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            icon: Icons.tune,
            label: state.activeFilterCount > 0
                ? 'Filtros (${state.activeFilterCount})'
                : 'Filtros',
            selected: state.hasFilters,
            onTap: () => _openAllFilters(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: VerticalDivider(width: 1, color: context.palette.border),
          ),
          _FilterChip(
            label: state.expiry == ExpiryFilter.any
                ? 'Vencimiento'
                : state.expiry.label,
            selected: state.expiry != ExpiryFilter.any,
            dropdown: true,
            onTap: () => _openExpiry(context),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: state.minDiscount == null
                ? 'Descuento'
                : '${state.minDiscount}% o más',
            selected: state.minDiscount != null,
            dropdown: true,
            onTap: () => _openDiscount(context),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: businessCount == 0
                ? 'Negocio'
                : businessCount == 1
                ? state.businesses
                      .firstWhere(
                        (b) => state.businessIds.contains(b.id),
                        orElse: () => (id: '', name: '1 negocio'),
                      )
                      .name
                : '$businessCount negocios',
            selected: businessCount > 0,
            dropdown: true,
            onTap: () => _openBusinesses(context),
          ),
        ],
      ),
    );
  }

  Future<void> _openExpiry(BuildContext context) async {
    final cubit = context.read<OffersFeedCubit>();
    final picked = await _showOptionsSheet<ExpiryFilter>(
      context,
      title: 'Vencimiento',
      options: [for (final e in ExpiryFilter.values) (e, e.label)],
      selected: cubit.state.expiry,
    );
    if (picked != null) cubit.setExpiry(picked.$1);
  }

  Future<void> _openDiscount(BuildContext context) async {
    final cubit = context.read<OffersFeedCubit>();
    final picked = await _showOptionsSheet<int?>(
      context,
      title: 'Descuento mínimo',
      options: [
        (null, 'Cualquier descuento'),
        for (final p in OffersFeedState.discountOptions) (p, '$p% o más'),
      ],
      selected: cubit.state.minDiscount,
    );
    if (picked != null) cubit.setMinDiscount(picked.$1);
  }

  Future<void> _openBusinesses(BuildContext context) async {
    final cubit = context.read<OffersFeedCubit>();
    final picked = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.palette.surface,
      builder: (_) => _BusinessPicker(
        businesses: cubit.state.businesses,
        initial: cubit.state.businessIds,
      ),
    );
    if (picked != null) cubit.setBusinessIds(picked);
  }

  Future<void> _openAllFilters(BuildContext context) async {
    final cubit = context.read<OffersFeedCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: context.palette.surface,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const _AllFiltersSheet()),
    );
  }
}

/// Single-choice sheet. Returns a record so "Cualquiera" (`null`) can be told
/// apart from dismissing the sheet.
Future<(T,)?> _showOptionsSheet<T>(
  BuildContext context, {
  required String title,
  required List<(T, String)> options,
  required T selected,
}) {
  return showModalBottomSheet<(T,)>(
    context: context,
    showDragHandle: true,
    backgroundColor: context.palette.surface,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(title),
          for (final option in options)
            ListTile(
              title: Text(option.$2),
              trailing: option.$1 == selected
                  ? const Icon(Icons.check_circle, color: AppColors.purple)
                  : null,
              onTap: () => Navigator.of(sheetContext).pop((option.$1,)),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: context.palette.textPrimary,
        ),
      ),
    );
  }
}

class _BusinessPicker extends StatefulWidget {
  const _BusinessPicker({required this.businesses, required this.initial});

  final List<({String id, String name})> businesses;
  final Set<String> initial;

  @override
  State<_BusinessPicker> createState() => _BusinessPickerState();
}

class _BusinessPickerState extends State<_BusinessPicker> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetTitle('Negocio'),
            Flexible(
              child: widget.businesses.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No hay negocios con ofertas activas'),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (final business in widget.businesses)
                          CheckboxListTile(
                            value: _selected.contains(business.id),
                            activeColor: AppColors.purple,
                            title: Text(business.name),
                            onChanged: (checked) => setState(() {
                              if (checked ?? false) {
                                _selected.add(business.id);
                              } else {
                                _selected.remove(business.id);
                              }
                            }),
                          ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(<String>{}),
                    child: const Text('Limpiar'),
                  ),
                  const Spacer(),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.purple,
                    ),
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: const Text('Aplicar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Filtros": every filter in one sheet, applied live.
class _AllFiltersSheet extends StatelessWidget {
  const _AllFiltersSheet();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OffersFeedCubit>();
    final state = cubit.state;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          children: [
            Row(
              children: [
                Text(
                  'Filtros',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.palette.textPrimary,
                  ),
                ),
                const Spacer(),
                if (state.hasFilters)
                  TextButton(
                    onPressed: cubit.clearFilters,
                    child: const Text('Limpiar'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const _GroupLabel('Vencimiento'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in ExpiryFilter.values)
                  _FilterChip(
                    label: e.label,
                    selected: state.expiry == e,
                    onTap: () => cubit.setExpiry(e),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const _GroupLabel('Descuento mínimo'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'Cualquiera',
                  selected: state.minDiscount == null,
                  onTap: () => cubit.setMinDiscount(null),
                ),
                for (final p in OffersFeedState.discountOptions)
                  _FilterChip(
                    label: '$p%+',
                    selected: state.minDiscount == p,
                    onTap: () => cubit.setMinDiscount(p),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const _GroupLabel('Negocio'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final business in state.businesses)
                  _FilterChip(
                    label: business.name,
                    selected: state.businessIds.contains(business.id),
                    onTap: () {
                      final ids = {...state.businessIds};
                      if (!ids.remove(business.id)) ids.add(business.id);
                      cubit.setBusinessIds(ids);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.purple,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ver ofertas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: context.palette.textSecondary,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.dropdown = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool dropdown;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = selected ? AppColors.purple : palette.textPrimary;
    return Material(
      color: selected ? palette.purpleSurface : palette.surface,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? AppColors.purple : palette.border),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              if (dropdown) ...[
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
