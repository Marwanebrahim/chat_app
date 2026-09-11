import 'package:chat_app/core/themes/app_colors.dart';
import 'package:chat_app/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get appTextStyles => Theme.of(this).extension<AppTextStyles>()!;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension StringExtrnsions on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
