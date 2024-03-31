import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  static final defaultTheme = () {
    final sourceTheme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.yellow),
    );

    return sourceTheme.copyWith(
      scaffoldBackgroundColor: AppPalette.white,
    );
  }();
}