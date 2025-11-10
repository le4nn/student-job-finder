import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Purple to Lilac Gradient
  static const Color primary = Color(0xFF9B7EDE); // Soft purple
  static const Color primaryDark = Color(0xFF7B5FC9); // Deeper purple
  static const Color primaryLight = Color(0xFFB8A4E8); // Light lilac
  static const Color accent = Color(0xFFD4C5F9); // Very light lilac
  
  // Secondary Colors - Soft pastels
  static const Color secondary = Color(0xFFA8D8EA); // Soft blue
  static const Color secondaryDark = Color(0xFF7FB3D5); // Muted blue
  static const Color secondaryLight = Color(0xFFD4E9F7); // Very light blue
  
  // Background Colors - Clean whites and light grays
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFF7F7F9); // Light gray
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color inputBackground = Color(0xFFF8F9FA);
  
  // Text Colors - Soft and readable
  static const Color textPrimary = Color(0xFF2D3748); // Soft dark gray
  static const Color textSecondary = Color(0xFF718096); // Medium gray
  static const Color textTertiary = Color(0xFFA0AEC0); // Light gray
  
  // Status Colors - Soft pastels
  static const Color success = Color(0xFF81C995); // Soft green
  static const Color warning = Color(0xFFFFC48C); // Soft orange
  static const Color error = Color(0xFFFF9B9B); // Soft red
  static const Color info = Color(0xFF94C9FF); // Soft blue
  
  // Border Colors - Very subtle
  static const Color border = Color(0xFFE8E8F0); // Light purple-gray
  static const Color borderLight = Color(0xFFF0F0F5); // Very light
  static const Color divider = Color(0xFFEDEDF3); // Subtle divider
  
  // Shadow Colors - Soft and subtle
  static const Color shadow = Color(0x0F9B7EDE); // Purple-tinted shadow
  static const Color shadowLight = Color(0x08000000); // Very light shadow
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF9B7EDE), // Purple
    Color(0xFFB8A4E8), // Lilac
  ];
  
  static const List<Color> cardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF7F7F9),
  ];
  
  static Color get grey50 => Colors.grey[50]!;
  static Color get grey100 => Colors.grey[100]!;
  static Color get grey200 => Colors.grey[200]!;
  static Color get grey300 => Colors.grey[300]!;
  static Color get grey600 => Colors.grey[600]!;
  static Color get grey800 => Colors.grey[800]!;
  
  static Color get blue50 => Colors.blue[50]!;
  
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color blue = Colors.blue;
  
  static const Color snackbarError = Color(0xFFFF9B9B);
  static const Color snackbarSuccess = Color(0xFF81C995);
}
