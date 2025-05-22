import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.blue500,
    primaryColorLight: AppColors.blue300,
    primaryColorDark: AppColors.blue700,
    hintColor: AppColors.yellow600,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.montserratTextTheme().copyWith(),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.blue500,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.blue500,
      secondary: AppColors.yellow600,
      surface: Colors.white,
      error: AppColors.red600,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.black900,
      onError: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(15),
        shadowColor: WidgetStatePropertyAll(
          AppColors.blue500.withAlpha((.4 * 255).toInt()),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        iconColor: const WidgetStatePropertyAll(Colors.white),
        // fixedSize: const WidgetStatePropertyAll(Size(330, 55)),
        textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
        backgroundColor: const WidgetStatePropertyAll(AppColors.blue500),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        //
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.blue500,
    primaryColorLight: AppColors.blue300,
    primaryColorDark: AppColors.blue700,
    hintColor: AppColors.yellow600,
    scaffoldBackgroundColor: AppColors.black900,
    textTheme: GoogleFonts.montserratTextTheme().copyWith(),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.blue500,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue500,
      secondary: AppColors.yellow600,
      surface: AppColors.black800,
      error: AppColors.red600,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onError: Colors.black,
    ).copyWith(surface: AppColors.black900),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(15),
        shadowColor: WidgetStatePropertyAll(
          AppColors.blue500.withAlpha((.4 * 255).toInt()),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        iconColor: const WidgetStatePropertyAll(Colors.white),
        fixedSize: const WidgetStatePropertyAll(Size(350, 55)),
        textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
        backgroundColor: const WidgetStatePropertyAll(AppColors.blue500),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        //
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
