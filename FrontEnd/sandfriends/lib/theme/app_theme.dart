import 'package:flutter/material.dart';
import './colors.dart';

class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(fontFamily: "Lexend");
  }
}
