import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Palette
  static const Color primary = Color(0xFF0A4D62);
  static const Color primaryLight = Color(0xFF186882);
  static const Color primaryDark = Color(0xFF063342);

  // Light Theme Palette
  static const Color lightScaffold = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFCBD5E1);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Palette (Modern Slate / Deep Navy)
  static const Color darkScaffold = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceSubtle = Color(0xFF26334D);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkBorderSubtle = Color(0xFF475569);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);
  static const Color darkPrimary = Color(0xFF147A9A);
  static const Color darkPrimaryAccent = Color(0xFF38BDF8);

  // Backwards compatibility
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
}
