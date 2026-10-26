import 'package:flutter/material.dart';

class AppColors {
  // Primary Green Palette
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySurface = Color(0xFFE8F5E9);
  static const Color primaryAccent = Color(0xFF00E676);

  // Secondary
  static const Color secondary = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF4DB6AC);

  // Background
  static const Color background = Color(0xFFF5FFF6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F7F0);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // XP Bar
  static const Color xpBar = Color(0xFF66BB6A);
  static const Color xpBarBackground = Color(0xFFE0E0E0);

  // Rank Colors
  static const Color rankBronze = Color(0xFFCD7F32);
  static const Color rankSilver = Color(0xFFC0C0C0);
  static const Color rankGold = Color(0xFFFFD700);
  static const Color rankDiamond = Color(0xFF42A5F5);
  static const Color rankMaster = Color(0xFF7E57C2);
  static const Color rankLegend = Color(0xFFFF7043);
  static const Color rankMythic = Color(0xFFE91E63);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
