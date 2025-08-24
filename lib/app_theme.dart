import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Your custom color palette
const Color primaryColor = Color.fromARGB(255, 77, 42, 146);
const Color onPrimaryColor = Color.fromARGB(255, 255, 255, 255);
const Color secondaryColor = Color.fromARGB(255, 235, 235, 235);
const Color onSecondaryColor = Color.fromARGB(255, 0, 0, 0);
const Color surface = Color.fromARGB(255, 219, 219, 219);
const Color onSurface = Color.fromARGB(255, 0, 0, 0);

// Your custom text styles
// The complete TextTheme
final TextTheme appTextTheme = TextTheme(
  // Heading styles (used for prominent titles)
  headlineLarge: GoogleFonts.roboto(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: onSurface,
  ),
  headlineMedium: GoogleFonts.roboto(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: onSurface,
  ),
  headlineSmall: GoogleFonts.roboto(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: onSurface,
  ),

  // Title styles (used for app bar titles, card titles, etc.)
  titleLarge: GoogleFonts.roboto(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: onSurface,
  ),
  titleMedium: GoogleFonts.roboto(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: onSurface,
  ),
  titleSmall: GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: onSurface,
  ),

  // Body styles (for main body text)
  bodyLarge: GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: onSurface,
  ),
  bodyMedium: GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: onSurface,
  ),
  bodySmall: GoogleFonts.roboto(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color:
        onSurface.withOpacity(0.7), // Slightly dimmer for less important text
  ),

  // Label styles (for button text, captions)
  labelLarge: GoogleFonts.roboto(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: onSurface,
  ),
  labelMedium: GoogleFonts.roboto(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: onSurface,
  ),
  labelSmall: GoogleFonts.roboto(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: onSurface,
  ),
);

// Your main app theme
final ThemeData appTheme = ThemeData(
  // Define color scheme
  colorScheme: const ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surface,
    error: Colors.red,
    onPrimary: onPrimaryColor,
    onSecondary: onSecondaryColor,
    onSurface: onSurface,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  // Define text theme
  textTheme: appTextTheme,
  // Other theme properties can be defined here
  // For example, card theme, button theme, etc.
);
