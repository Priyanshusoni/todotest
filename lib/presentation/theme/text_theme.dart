import 'package:flutter/material.dart';
import 'package:todo/core/utils/keys.dart';
import 'package:todo/presentation/theme/app_theme.dart';

class AppTextTheme {
  static const fontFamily = 'Oswald';
  // static const String? fontFamily = null;

  static TextTheme get textTheme =>
      Theme.of(Keys.navigatorKey.currentContext!).textTheme;

  // static TextStyle? get displayLarge => textTheme.displayLarge; // 57
  // static TextStyle? get displayMedium => textTheme.displayMedium; // 45
  // static TextStyle? get displaySmall => textTheme.displaySmall; // 36

  static TextStyle? get headlineLarge => textTheme.headlineLarge; // 32
  // static TextStyle? get headlineMedium => textTheme.headlineMedium; // 28
  // static TextStyle? get headlineSmall => textTheme.headlineSmall; // 24

  static TextStyle? get titleLarge => textTheme.titleLarge; // 22
  // static TextStyle? get titleSemiLarge =>
  //     textTheme.titleLarge?.copyWith(fontSize: 18); // 18
  // static TextStyle? get titleMedium => textTheme.titleMedium; // 16
  // static TextStyle? get titleSmall => textTheme.titleSmall; // 14

  // static TextStyle? get bodyLarge18 =>
  //     textTheme.bodyLarge?.copyWith(fontSize: 18); // 18
  // static TextStyle? get bodyLarge => textTheme.bodyLarge; // 16
  // static TextStyle? get bodyMedium => textTheme.bodyMedium; // 14
  // static TextStyle? get bodySmall => textTheme.bodySmall; // 12

  // static TextStyle? get labelLarge => textTheme.labelLarge; // 14
  // static TextStyle? get labelMedium => textTheme.labelMedium; // 12
  // static TextStyle? get labelSmall => textTheme.labelSmall; // 11

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    letterSpacing: 0,
  ); // 18
  static const subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    letterSpacing: 0,
  ); // 16
  static const body = TextStyle(fontFamily: fontFamily, fontSize: 14); // 14
  static const caption = TextStyle(fontFamily: fontFamily, fontSize: 12); // 12
  static const captionSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
  ); // 11

  static const white = TextStyle(
    color: AppTheme.whiteColor,
    fontFamily: fontFamily,
  );
  static const black = TextStyle(
    color: AppTheme.blackColor,
    fontFamily: fontFamily,
  );
  static const grey = TextStyle(
    color: AppTheme.greyColor,
    fontFamily: fontFamily,
  );
  static final greyDark = TextStyle(
    color: AppTheme.greyColor.shade800,
    fontFamily: fontFamily,
  );
  static const red = TextStyle(
    color: AppTheme.redColor,
    fontFamily: fontFamily,
  );
  static const green = TextStyle(
    color: AppTheme.greenColor,
    fontFamily: fontFamily,
  );
  static final primary = TextStyle(
    color: AppTheme.primaryColor,
    fontFamily: fontFamily,
  );

  static const bold = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );
  static const semiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  static const normal = TextStyle(
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );
}
