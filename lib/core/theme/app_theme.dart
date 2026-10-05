import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';

/// Light and dark [ThemeData] for `MaterialApp`.
abstract final class AppTheme {
  /// Same as Flutter's default theme (what the app shipped with) plus the
  /// light palette, so light mode looks exactly as before.
  static final ThemeData light = ThemeData(
    extensions: const [AppPalette.light],
  );

  static final ThemeData dark = _buildDark();

  static ThemeData _buildDark() {
    const palette = AppPalette.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.purple,
          brightness: Brightness.dark,
        ).copyWith(
          // Buttons that only override the background (WhatsApp, purple CTAs)
          // rely on onPrimary being white, as it is in the light theme.
          primary: AppColors.purple,
          onPrimary: Colors.white,
          surface: palette.page,
          onSurface: palette.textPrimary,
        );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.page,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.page,
        surfaceTintColor: palette.page,
        foregroundColor: palette.textPrimary,
      ),
      dividerColor: palette.neutralBorder,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        modalBackgroundColor: palette.surface,
      ),
      dialogTheme: DialogThemeData(backgroundColor: palette.surface),
      extensions: const [palette],
    );
  }
}
