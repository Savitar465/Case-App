import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';

/// White page with a back arrow and a centered title, shared by every
/// settings screen.
class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBack = true,
  });

  final String title;
  final Widget body;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.page,
      appBar: AppBar(
        backgroundColor: context.palette.page,
        surfaceTintColor: context.palette.page,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                tooltip: 'Volver',
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: context.palette.textSecondary,
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.palette.textPrimary,
          ),
        ),
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}

/// Bold heading above a [SettingsGroup] ("Cuenta", "Gestión", ...).
class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

/// Rounded white card that stacks its children with thin dividers.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: context.palette.border),
      ),
      // Own Material so ListTile ink and tileColor stay inside the rounded
      // card instead of painting on the page behind it.
      child: Material(
        color: context.palette.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0)
                Divider(height: 1, indent: 56, color: context.palette.border),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// Icon + label + chevron row inside a [SettingsGroup].
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Defaults to the primary text colour.
  final Color? color;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.palette.textPrimary;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      trailing: showChevron
          ? Icon(Icons.chevron_right, color: context.palette.textMuted)
          : null,
    );
  }
}

/// Label above a rounded field, as in the "Cambiar contraseña" and
/// "Correo electrónico" mockups.
class SettingsTextField extends StatelessWidget {
  const SettingsTextField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.onToggleObscure,
    this.readOnly = false,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final bool readOnly;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.palette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: readOnly
                ? context.palette.textSecondary
                : context.palette.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: readOnly
                ? context.palette.mutedFill
                : context.palette.surface,
            prefixIcon: icon == null
                ? null
                : Icon(icon, color: context.palette.textSecondary, size: 22),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    tooltip: obscureText
                        ? 'Mostrar contraseña'
                        : 'Ocultar contraseña',
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.palette.textSecondary,
                    ),
                  ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: border(
              readOnly ? Colors.transparent : context.palette.border,
            ),
            focusedBorder: border(AppColors.purple, 1.5),
            errorBorder: border(Colors.redAccent),
            focusedErrorBorder: border(Colors.redAccent, 1.5),
          ),
        ),
      ],
    );
  }
}

/// Full-width purple button with an optional leading icon and spinner.
class SettingsPrimaryButton extends StatelessWidget {
  const SettingsPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.purple,
          disabledBackgroundColor: AppColors.purple.withValues(alpha: 0.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

/// Tinted card with an icon, a bold title and a short explanation.
class SettingsInfoCard extends StatelessWidget {
  const SettingsInfoCard({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.color = AppColors.purple,
    this.background,
  });

  final IconData icon;
  final String? title;
  final String message;
  final Color color;

  /// Defaults to the palette's soft purple.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background ?? context.palette.purpleSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows [message] as a floating snackbar, replacing any visible one.
void showSettingsSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));
}
