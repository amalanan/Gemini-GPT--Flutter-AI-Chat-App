import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF4F8EF7);
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF93C5FD);
  static const Color accent = Color(0xFF8B5CF6);

  // Gemini Gradient Colors
  static const Color geminiBlue = Color(0xFF4285F4);
  static const Color geminiPurple = Color(0xFF9333EA);
  static const Color geminiTeal = Color(0xFF0EA5E9);

  // Light Theme
  static const Color lightBackground = Color(0xFFF8F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextHint = Color(0xFF9CA3AF);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF1A1D27);
  static const Color darkCardBg = Color(0xFF1E2130);
  static const Color darkBorder = Color(0xFF2D3148);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextHint = Color(0xFF6B7280);

  // Chat Bubbles - User
  static const Color userBubbleLight = Color(0xFF4F8EF7);
  static const Color userBubbleDark = Color(0xFF2563EB);
  static const Color userBubbleText = Color(0xFFFFFFFF);

  // Chat Bubbles - AI
  static const Color aiBubbleLight = Color(0xFFFFFFFF);
  static const Color aiBubbleDark = Color(0xFF1E2130);
  static const Color aiTextLight = Color(0xFF111827);
  static const Color aiTextDark = Color(0xFFF9FAFB);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Input Field
  static const Color inputBgLight = Color(0xFFF3F4F6);
  static const Color inputBgDark = Color(0xFF252836);

  // Gradients
  static const LinearGradient geminiGradient = LinearGradient(
    colors: [geminiBlue, geminiPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0F1117), Color(0xFF1A1D27), Color(0xFF0F1117)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
