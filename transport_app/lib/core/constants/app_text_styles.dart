import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'MiSans';
  static const List<String> fontFallback = ['MiSansKhmer'];

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.font3XL,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.font2XL,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontXL,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  // Subtitle
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontLG,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontMD,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontSM,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontXS,
    color: AppColors.textSecondary,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontMD,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  // Label
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontSM,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Accent
  static const TextStyle accent = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    fontSize: AppSizes.fontMD,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
  );
}