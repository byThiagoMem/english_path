import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  /// [fontSize: 50, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle heading50({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.openSans(
      fontSize: 50,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// [fontSize: 35, FontWeight.w400, ITColors.neutral900, letterSpacing: -.5]
  static TextStyle heading35({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = -.5,
  }) =>
      GoogleFonts.openSans(
        fontSize: 35,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 30, FontWeight.w400, Colors.black87, letterSpacing: 0]
  static TextStyle heading30({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 30,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 28, FontWeight.w400, Colors.black87, letterSpacing: 0]
  static TextStyle heading28({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 28,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 26, FontWeight.w700, Colors.black87, letterSpacing: -.24]
  static TextStyle heading26({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w700,
    double letterSpacing = -.24,
  }) =>
      GoogleFonts.openSans(
        fontSize: 26,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 24, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle heading24({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 24,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 22, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle heading22({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 22,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 20, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle heading20({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 20,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 18, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle bodyLarge({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 18,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 16, FontWeight.w700, Colors.black87, letterSpacing: 0]
  static TextStyle bodyMedium({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w700,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 14, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle bodySmall({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 12, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle bodyXSmall({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 10, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle bodyCaption({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 10,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// [fontSize: 9, FontWeight.w500, Colors.black87, letterSpacing: 0]
  static TextStyle bodyXCaption({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.openSans(
        fontSize: 9,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );
}
