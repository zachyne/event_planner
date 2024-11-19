import 'package:flutter/material.dart';

class GlobalThemeData {
  static final ColorScheme colorScheme =
      ColorScheme.fromSeed(seedColor: Colors.pink);

  static final ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Poppins', // Set the default font family to Poppins
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimaryContainer,
      titleTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(colorScheme.primary),
        foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
      ),
    ),
    cardTheme: CardTheme(
      color:
          colorScheme.primaryContainer, // Use a different color from the scheme
      elevation: 2,
      shadowColor: colorScheme.onSurface.withOpacity(0.2),
    ),
  );
}
