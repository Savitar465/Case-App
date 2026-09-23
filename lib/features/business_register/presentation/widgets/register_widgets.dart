import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const Color kFieldBorder = Color(0xFFE7D9E9);

/// Top bar with a "Guardar y salir" pill and an optional progress bar.
class WizardTopBar extends StatelessWidget {
  const WizardTopBar({
    super.key,
    required this.onExit,
    this.exitLabel = 'Guardar y salir',
    this.progress,
  });

  final VoidCallback onExit;
  final String exitLabel;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: onExit,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: Text(
              exitLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEFEFEF),
              valueColor: const AlwaysStoppedAnimation(AppColors.purple),
            ),
          ),
        ],
      ],
    );
  }
}

/// Large bold step heading.
class StepTitle extends StatelessWidget {
  const StepTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
    );
  }
}

/// Muted step subtitle / helper text.
class StepSubtitle extends StatelessWidget {
  const StepSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: Colors.black54, height: 1.3),
    );
  }
}

/// Rounded outlined text field used throughout the wizard.
class WizardTextField extends StatelessWidget {
  const WizardTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.filled = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool filled;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: border(kFieldBorder),
        focusedBorder: border(AppColors.purple),
        border: border(kFieldBorder),
      ),
    );
  }
}

/// Full-width solid purple button.
class WizardPrimaryButton extends StatelessWidget {
  const WizardPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.purple,
          disabledBackgroundColor: AppColors.purple.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
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
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

/// "Atrás" (text) on the left and "Siguiente" (solid) on the right.
class WizardFooterNav extends StatelessWidget {
  const WizardFooterNav({
    super.key,
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Siguiente',
    this.nextEnabled = true,
    this.isLoading = false,
  });

  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;
  final bool nextEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
            child: const Text(
              'Atrás',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        const Spacer(),
        SizedBox(
          height: 50,
          child: FilledButton(
            onPressed: (nextEnabled && !isLoading) ? onNext : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.purple,
              disabledBackgroundColor: AppColors.purple.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(horizontal: 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    nextLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Bold field label (e.g. "NOMBRE OFICIAL").
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.uppercase = false});

  final String text;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Text(
      uppercase ? text.toUpperCase() : text,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
    );
  }
}
