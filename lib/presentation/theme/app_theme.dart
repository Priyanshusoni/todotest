import 'package:todo/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // static const primaryColor = MaterialColor(
  //   0xff506ee4,
  //   GetMaterialColor.primaryColor,
  // );
  static final primaryColor = _materialColorFromHex(const Color(0xff506ee4));

  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const redColor = Colors.red;
  static const greenColor = Colors.green;
  static const blueColor = Colors.blue;
  static const greyColor = Colors.grey;
  static const purpleColor = Colors.purple;

  static const shadowColor = Colors.black12;
  static const shadowColorMedium = Colors.black26;

  static const linerGradientColors = [Color(0xfff79f9b), Color(0xff0f4069)];

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  );

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: colorScheme,
    fontFamily: AppTextTheme.fontFamily,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // ANDROID
        statusBarBrightness: Brightness.light, // iOS
      ),
    ),
  );
}

MaterialColor _materialColorFromHex(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};

  final r = (color.r * 255).round().clamp(0, 255);
  final g = (color.g * 255).round().clamp(0, 255);
  final b = (color.b * 255).round().clamp(0, 255);

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      (r + ((ds < 0 ? r : (255 - r)) * ds)).round().clamp(0, 255),
      (g + ((ds < 0 ? g : (255 - g)) * ds)).round().clamp(0, 255),
      (b + ((ds < 0 ? b : (255 - b)) * ds)).round().clamp(0, 255),
      1,
    );
  }

  return MaterialColor(color.toARGB32(), swatch);
}
