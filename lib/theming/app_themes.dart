import 'package:app/models/theme_state_model.dart';
import 'package:flutter/material.dart';

import '../models/shimmer_colors_model.dart';

class AppColors {
  static const primary = Color(0xFF0D47A1); // Deep Blue
  static const secondary = Color(0xFF0097A7); // Teal
  static const accent = Color(0xFFFFC107); // Amber
  static const lightBackground = Color(0xFFF5F7FA);
  static const darkBackground = Color(0xFF121212);
  static const lightSurface = Colors.white;
  static const darkSurface = Color(0xFF1E1E1E);
}

class AppThemes {
  final ThemeStateModel themeState;
  const AppThemes(this.themeState);

  static final appBarTheme = AppBarTheme(
    iconTheme: const IconThemeData(color: Colors.white),
    elevation: 3,
    // centerTitle: true,
    toolbarHeight: kToolbarHeight + 15,
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Colors.white,
    ),
  );

  static final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static final dividerThemeLight = DividerThemeData(
    color: Colors.grey.shade300,
    thickness: 0.75,
  );

  static final dividerThemeDark = DividerThemeData(
    color: Colors.grey.shade700,
    thickness: 0.75,
  );

  static final textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.primary,
    ),
  );

  ThemeData get lightTheme => ThemeData(
    fontFamily: themeState.fontFamily,
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: appBarTheme.copyWith(backgroundColor: AppColors.primary),
    floatingActionButtonTheme: floatingActionButtonTheme,
    dividerTheme: dividerThemeLight,
    dividerColor: dividerThemeLight.color,
    textTheme: textTheme,
    cardTheme: const CardThemeData(
      color: AppColors.lightSurface,
      elevation: 1,
      margin: EdgeInsets.all(8),
    ),
    cardColor: AppColors.lightSurface,
    extensions: <ThemeExtension<dynamic>>[
      ShimmerColorsModel(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
      ),
    ],
  );
  ThemeData get darkTheme => ThemeData(
    fontFamily: themeState.fontFamily,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.darkSurface,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: appBarTheme.copyWith(backgroundColor: Colors.grey.shade900),
    floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
      backgroundColor: AppColors.accent,
    ),
    dividerTheme: dividerThemeDark,
    dividerColor: dividerThemeDark.color,
    textTheme: textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 1,
      margin: EdgeInsets.all(8),
    ),
    cardColor: AppColors.darkSurface,
    extensions: <ThemeExtension<dynamic>>[
      ShimmerColorsModel(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade600,
      ),
    ],
  );
}

// import 'package:app/models/theme_state_model.dart';
// import 'package:flutter/material.dart';

// class AppThemes {
//   final ThemeStateModel themeState;
//   const AppThemes(this.themeState);
//   static final appBarTheme = AppBarTheme(
//     iconTheme: const IconThemeData(color: Colors.white),
//     backgroundColor: Colors.lightBlue.shade900,
//     toolbarHeight: kToolbarHeight + 15,
//     titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
//   );
//   static final floatingActionButtonTheme = FloatingActionButtonThemeData(
//     backgroundColor: Colors.cyan.shade900,
//     iconSize: 36,
//   );

//   static final dividerTheme = DividerThemeData(
//     color: Colors.grey.shade400,
//     thickness: .75,
//   );

//   ThemeData get theme => ThemeData(
//     appBarTheme: appBarTheme,
//     floatingActionButtonTheme: floatingActionButtonTheme,
//     dividerTheme: dividerTheme,
//     // fontFamily: 'LexendDeca',
//     fontFamily: themeState.fontFamily,
//   );

//   ThemeData get darkTheme => theme.copyWith(
//     primaryColor: Colors.lightBlue.shade900,
//     cardColor: Colors.black87,
//     iconTheme: const IconThemeData(color: Colors.white),
//     scaffoldBackgroundColor: Colors.black,
//     colorScheme: const ColorScheme.dark(),
//   );

//   ThemeData get lightTheme => theme.copyWith(
//     primaryColor: Colors.lightBlue.shade900,
//     cardTheme: CardThemeData(color: Colors.white, elevation: 0),
//     dividerTheme: dividerTheme,
//     iconTheme: IconThemeData(color: Colors.grey.shade800),
//     scaffoldBackgroundColor: Colors.grey.shade200,
//     colorScheme: const ColorScheme.light(),
//   );
// }
