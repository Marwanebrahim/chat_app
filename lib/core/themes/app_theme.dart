import 'package:chat_app/core/themes/app_colors.dart';
import 'package:chat_app/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => _build(
    colors: AppColors.light,
    textStyles: AppTextStyles.light(AppColors.light),
    brightness: Brightness.light,
  );

  static ThemeData get darkTheme => _build(
    colors: AppColors.dark,
    textStyles: AppTextStyles.dark(AppColors.dark),
    brightness: Brightness.dark,
  );

  static ThemeData _build({
    required AppColors colors,
    required AppTextStyles textStyles,
    required Brightness brightness,
  }) {
    return ThemeData(
      brightness: brightness,
      extensions: [colors, textStyles],
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        foregroundColor: colors.lightPurple,
        backgroundColor: colors.appBarBackground,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.white,
        hintStyle: textStyles.bodyLarge ,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.borderColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.borderColor.withValues(alpha: 0.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.red.withValues(alpha: 0.5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.borderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
