import 'package:flutter/material.dart';

/// Neutral colours that change with the theme brightness. Brand accents
/// (purple, offer red, flame...) stay in [AppColors]; anything that was a
/// hardcoded white background, black text or light-grey border reads from
/// here via `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.page,
    required this.pageTinted,
    required this.surface,
    required this.mutedFill,
    required this.purpleSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.faint,
    required this.border,
    required this.neutralBorder,
    required this.shadow,
  });

  /// Background of plain pages (white in light mode).
  final Color page;

  /// Background of the lavender-tinted pages (home, favourites list).
  final Color pageTinted;

  /// Cards, fields, chips and bars that sit on top of a page.
  final Color surface;

  /// Grey fills: read-only fields, placeholders, unselected tiles.
  final Color mutedFill;

  /// Soft purple tint for selected pills and promo cards.
  final Color purpleSurface;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;

  /// Very low-contrast icons / outlines (was `Colors.black26`).
  final Color faint;

  /// Lavender-ish outline of cards and inputs.
  final Color border;

  /// Grey outline for neutral buttons and dividers.
  final Color neutralBorder;

  final Color shadow;

  static const light = AppPalette(
    page: Colors.white,
    pageTinted: Color(0xFFF8F5FC),
    surface: Colors.white,
    mutedFill: Color(0xFFF2F2F4),
    purpleSurface: Color(0xFFF5EEFF),
    textPrimary: Colors.black87,
    textSecondary: Colors.black54,
    textTertiary: Colors.black45,
    textMuted: Colors.black38,
    faint: Colors.black26,
    border: Color(0xFFE3D9F5),
    neutralBorder: Color(0xFFE0E0E0),
    shadow: Color(0x14000000),
  );

  static const dark = AppPalette(
    page: Color(0xFF131118),
    pageTinted: Color(0xFF131118),
    surface: Color(0xFF1F1B26),
    mutedFill: Color(0xFF2A2631),
    purpleSurface: Color(0xFF2E2242),
    textPrimary: Color(0xEBFFFFFF),
    textSecondary: Color(0xB3FFFFFF),
    textTertiary: Color(0x99FFFFFF),
    textMuted: Color(0x73FFFFFF),
    faint: Color(0x4DFFFFFF),
    border: Color(0xFF3A3248),
    neutralBorder: Color(0xFF3A3741),
    shadow: Color(0x59000000),
  );

  @override
  AppPalette copyWith({
    Color? page,
    Color? pageTinted,
    Color? surface,
    Color? mutedFill,
    Color? purpleSurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textMuted,
    Color? faint,
    Color? border,
    Color? neutralBorder,
    Color? shadow,
  }) {
    return AppPalette(
      page: page ?? this.page,
      pageTinted: pageTinted ?? this.pageTinted,
      surface: surface ?? this.surface,
      mutedFill: mutedFill ?? this.mutedFill,
      purpleSurface: purpleSurface ?? this.purpleSurface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textMuted: textMuted ?? this.textMuted,
      faint: faint ?? this.faint,
      border: border ?? this.border,
      neutralBorder: neutralBorder ?? this.neutralBorder,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      page: Color.lerp(page, other.page, t)!,
      pageTinted: Color.lerp(pageTinted, other.pageTinted, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      mutedFill: Color.lerp(mutedFill, other.mutedFill, t)!,
      purpleSurface: Color.lerp(purpleSurface, other.purpleSurface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
      border: Color.lerp(border, other.border, t)!,
      neutralBorder: Color.lerp(neutralBorder, other.neutralBorder, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  /// The palette for the current theme brightness.
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
