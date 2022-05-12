import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mysoundboard/utils/database.dart';

// Color accentColor = Get.isDarkMode ? Colors.white :context.theme.colorScheme.secondary;
// Color accentColorAndWhite = Get.isDarkMode ? Colors.white :context.theme.colorScheme.secondary;

Color appColor = Color(Settings.appColor!);
Color? kAppDarkColor = Colors.grey[800];

const TextStyle dts =
    TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

// ignore: avoid_classes_with_only_static_members
class Themes {
  static final light = ThemeData.light().copyWith(
    toggleableActiveColor: appColor,
    inputDecorationTheme: const InputDecorationTheme().copyWith(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: appColor, width: 2))),
    colorScheme: const ColorScheme.light()
        .copyWith(primary: appColor, secondary: appColor, surface: appColor),
    primaryColor: appColor,
    canvasColor: appColor,
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
  );

  static final dark = ThemeData.dark().copyWith(
    inputDecorationTheme: const InputDecorationTheme().copyWith(
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2))),
    colorScheme: const ColorScheme.dark()
        .copyWith(secondary: kAppDarkColor, surface: kAppDarkColor),

    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white.withOpacity(.9),
        selectionColor: Colors.white30,
        selectionHandleColor: Colors.white.withOpacity(.9)),
    // primaryColor: kAppDarkColor,
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
  );
}
