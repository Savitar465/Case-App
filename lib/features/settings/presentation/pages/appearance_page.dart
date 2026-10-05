import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/theme_preference.dart';
import '../bloc/appearance_cubit.dart';
import '../widgets/settings_widgets.dart';

/// "Apariencia": system / light / dark. Drives the app-wide
/// [AppearanceCubit], so the change applies immediately.
class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  static const routeName = '/settings/appearance';

  static const _options = [
    (ThemePreference.system, Icons.brightness_auto_outlined, 'Sistema'),
    (ThemePreference.light, Icons.light_mode_outlined, 'Claro'),
    (ThemePreference.dark, Icons.dark_mode_outlined, 'Oscuro'),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Apariencia',
      body: BlocConsumer<AppearanceCubit, AppearanceState>(
        listenWhen: (prev, curr) =>
            curr.error != null && curr.error != prev.error,
        listener: (context, state) =>
            showSettingsSnackBar(context, state.error!),
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Elige cómo quieres ver la app. "Sistema" sigue la '
                'configuración de tu teléfono.',
                style: TextStyle(color: context.palette.textSecondary),
              ),
              const SizedBox(height: 20),
              SettingsGroup(
                children: [
                  for (final (preference, icon, label) in _options)
                    _ThemeOption(
                      icon: icon,
                      label: label,
                      selected: state.preference == preference,
                      onTap: () =>
                          context.read<AppearanceCubit>().select(preference),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: ListTile(
        onTap: onTap,
        tileColor: selected ? context.palette.mutedFill : null,
        leading: Icon(icon, color: context.palette.textPrimary),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: selected
              ? const Icon(
                  Icons.check_circle,
                  key: ValueKey('on'),
                  color: AppColors.purple,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  key: ValueKey('off'),
                  color: context.palette.textMuted,
                ),
        ),
      ),
    );
  }
}
