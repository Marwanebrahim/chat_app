import 'package:chat_app/core/constants/app_palette.dart';
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.white,
    required this.background,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.lightPurple,
    required this.purple,
    required this.paleViolet,
    required this.appBarBackground,
    required this.red,
    required this.dividerColor,
    required this.borderColor,
    required this.navBarBackground,
    required this.primaryGradient,
  });

  final Color white;
  final Color background;

  final Color text1;
  final Color text2;
  final Color text3;

  final Color lightPurple;
  final Color purple;
  final Color paleViolet;

  final Color appBarBackground;
  final Color red;
  final Color dividerColor;
  final Color borderColor;
  final Color navBarBackground;

  final Gradient primaryGradient;

  // =========================
  // Light Theme
  // =========================

  static final AppColors light = AppColors(
    white: AppLightPalette.white,
    background: AppLightPalette.background,

    text1: AppLightPalette.text1,
    text2: AppLightPalette.text2,
    text3: AppLightPalette.text3,

    lightPurple: AppLightPalette.lightPurple,
    purple: AppLightPalette.purple,
    paleViolet: AppLightPalette.paleViolet,

    appBarBackground: AppLightPalette.appBarBackground,
    red: AppLightPalette.red,
    dividerColor: AppLightPalette.dividerColor,
    borderColor: AppLightPalette.borderColor,
    navBarBackground: AppLightPalette.navBarBackground,

    primaryGradient: AppLightPalette.primaryGradient,
  );

  // =========================
  // Dark Theme
  // =========================

  static const AppColors dark = AppColors(
    white: AppDarkPalette.white,
    background: AppDarkPalette.background,

    text1: AppDarkPalette.text1,
    text2: AppDarkPalette.text2,
    text3: AppDarkPalette.text3,

    lightPurple: AppDarkPalette.lightPurple,
    purple: AppDarkPalette.purple,
    paleViolet: AppDarkPalette.paleViolet,

    appBarBackground: AppDarkPalette.appBarBackground,
    red: AppDarkPalette.red,
    dividerColor: AppDarkPalette.dividerColor,
    borderColor: AppDarkPalette.borderColor,
    navBarBackground: AppDarkPalette.navBarBackground,

    primaryGradient: AppDarkPalette.primaryGradient,
  );

  @override
  AppColors copyWith({
    Color? white,
    Color? background,
    Color? text1,
    Color? text2,
    Color? text3,
    Color? lightPurple,
    Color? purple,
    Color? paleViolet,
    Color? appBarBackground,
    Color? red,
    Color? dividerColor,
    Color? borderColor,
    Color? navBarBackground,
    Gradient? primaryGradient,
  }) {
    return AppColors(
      white: white ?? this.white,
      background: background ?? this.background,
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      lightPurple: lightPurple ?? this.lightPurple,
      purple: purple ?? this.purple,
      paleViolet: paleViolet ?? this.paleViolet,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      red: red ?? this.red,
      dividerColor: dividerColor ?? this.dividerColor,
      borderColor: borderColor ?? this.borderColor,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;

    return AppColors(
      white: Color.lerp(white, other.white, t)!,
      background: Color.lerp(background, other.background, t)!,
      text1: Color.lerp(text1, other.text1, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      text3: Color.lerp(text3, other.text3, t)!,
      lightPurple: Color.lerp(lightPurple, other.lightPurple, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      paleViolet: Color.lerp(paleViolet, other.paleViolet, t)!,
      appBarBackground: Color.lerp(
        appBarBackground,
        other.appBarBackground,
        t,
      )!,
      red: Color.lerp(red, other.red, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      navBarBackground: Color.lerp(
        navBarBackground,
        other.navBarBackground,
        t,
      )!,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
    );
  }
}
