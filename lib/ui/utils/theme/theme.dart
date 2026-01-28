import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: kcPrimaryColor,
    scaffoldBackgroundColor: kcBackgroundColor,
    textTheme: GoogleFonts.montserratTextTheme(),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: kcPrimaryColor.withAlpha(30),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: kcPrimaryColor,
    scaffoldBackgroundColor: kcDarkGreyColor,
    textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      surfaceTintColor: kcPrimaryColor.withAlpha(20),
      color: kcDarkGreyColor.withAlpha(200),
      shadowColor: kcPrimaryColor.withAlpha(50),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static SfDataGridThemeData dataGridTheme = SfDataGridThemeData(
    gridLineColor:
        kcLightGrey.withAlpha(100), // Lighter, less prominent grid lines
    gridLineStrokeWidth: 0.3, // Thinner grid lines
    headerColor:
        kcPrimaryColor.withAlpha(20), // Subtle purple tint on header hover
    headerHoverColor:
        kcPrimaryColor.withAlpha(100), // Subtle purple tint on header hover
    rowHoverColor:
        kcPrimaryColor.withAlpha(10), // Very subtle purple tint on row hover
    selectionColor:
        kcPrimaryColor.withAlpha(80), // More visible selection color
    currentCellStyle: const DataGridCurrentCellStyle(
      borderColor: kcPrimaryColor,
      borderWidth: 1,
    ),
  );
}
