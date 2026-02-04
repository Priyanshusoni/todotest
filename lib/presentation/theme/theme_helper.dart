import 'package:flutter/material.dart';
import 'package:todo/presentation/theme/app_theme.dart';

const vSpace32 = SizedBox(height: 32);
const vSpace24 = SizedBox(height: 24);
const vSpace20 = SizedBox(height: 20);
const vSpace16 = SizedBox(height: 16);
const vSpace12 = SizedBox(height: 12);
const vSpace8 = SizedBox(height: 8);
const vSpace6 = SizedBox(height: 6);
const vSpace4 = SizedBox(height: 4);
const vSpace2 = SizedBox(height: 2);

const hSpace32 = SizedBox(width: 32);
const hSpace24 = SizedBox(width: 24);
const hSpace20 = SizedBox(width: 20);
const hSpace16 = SizedBox(width: 16);
const hSpace12 = SizedBox(width: 12);
const hSpace8 = SizedBox(width: 8);
const hSpace6 = SizedBox(width: 6);
const hSpace4 = SizedBox(width: 4);
const hSpace2 = SizedBox(width: 2);

SizedBox get appBarHeight => const SizedBox(height: kToolbarHeight);

// final circular6 = BorderRadius.circular(6);
final circular12 = BorderRadius.circular(12);
final circular24 = BorderRadius.circular(24);
final rectShape = RoundedRectangleBorder(borderRadius: circular12);
final border = Border.all(color: AppTheme.greyColor.shade300);

const all2 = EdgeInsets.all(2);
const all4 = EdgeInsets.all(4);
const all6 = EdgeInsets.all(6);
const all8 = EdgeInsets.all(8);
const all10 = EdgeInsets.all(10);
const all12 = EdgeInsets.all(12);
const all16 = EdgeInsets.all(16);
const symmetricH2 = EdgeInsets.symmetric(horizontal: 2);
const symmetricH4 = EdgeInsets.symmetric(horizontal: 4);
const symmetricH8 = EdgeInsets.symmetric(horizontal: 8);
const symmetricH12 = EdgeInsets.symmetric(horizontal: 12);
const symmetricH16 = EdgeInsets.symmetric(horizontal: 16);
const symmetricV2 = EdgeInsets.symmetric(vertical: 2);
const symmetricV4 = EdgeInsets.symmetric(vertical: 4);
const symmetricV8 = EdgeInsets.symmetric(vertical: 8);
const symmetricV12 = EdgeInsets.symmetric(vertical: 12);
const symmetricV16 = EdgeInsets.symmetric(vertical: 16);

const shadow = BoxShadow(
  spreadRadius: 0,
  blurRadius: 10,
  color: AppTheme.shadowColor,
  offset: Offset(1, 2),
);

final basicDecoradtion = BoxDecoration(
  borderRadius: circular24,
  color: AppTheme.whiteColor,
);

final basicShadowDecoradtion = BoxDecoration(
  borderRadius: circular24,
  boxShadow: [shadow],
  color: AppTheme.whiteColor,
);
