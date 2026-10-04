import 'package:flutter/material.dart';

/// Brand palette taken from the `design/perfil.svg` mockup.
abstract final class AppColors {
  /// Primary purple accent used for links, selected pills and outlines.
  static const Color purple = Color(0xFFA658FF);

  /// Tinted purple background for list rows / soft surfaces.
  static const Color purpleSurface = Color(0xFFF5EEFF);

  /// WhatsApp green used for the contact buttons.
  static const Color whatsapp = Color(0xFF25D366);

  /// "Nuevo" badge green.
  static const Color badgeGreen = Color(0xFF2EB872);

  /// Star rating amber.
  static const Color star = Color(0xFFFFB400);

  /// Soft lavender page background used on the home screen.
  static const Color pageBackground = Color(0xFFF8F5FC);

  /// Red used for location pins and "oferta" badges.
  static const Color offerRed = Color(0xFFE53935);

  /// Orange used for the fire icon and the "OFERTA" / "PRO" pills.
  static const Color flame = Color(0xFFFF7A1A);
}
