import 'package:flutter/material.dart';

/// Single source of truth for every color in the app.
/// Never hardcode Color(...) or Colors.xxx inside screens/widgets.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0F9D8A); // teal
  static const Color primaryDark = Color(0xFF0B6E61);
  static const Color accent = Color(0xFFF5A623); // amber

  // Surfaces
  static const Color background = Color(0xFFF4F7F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFE6F4F1);
  static const Color border = Color(0xFFD9E3E0);

  // Text
  static const Color textPrimary = Color(0xFF1C2B2A);
  static const Color textSecondary = Color(0xFF6B7A78);

  // QR
  static const Color qrInk = Color(0xFF0B3B36);

  // Status
  static const Color error = Color(0xFFD64545);
  static const Color white = Color(0xFFFFFFFF);
}
