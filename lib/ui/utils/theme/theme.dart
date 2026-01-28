import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:mm_inventory_web/ui/common/app_colors.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: kcPrimaryColor,
    scaffoldBackgroundColor: kcBackgroundColor,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: kcPrimaryColor,
    scaffoldBackgroundColor: kcDarkGreyColor,
  );

  static SfDataGridThemeData dataGridTheme = SfDataGridThemeData(
    headerColor: kcMediumGrey.withAlpha(30), // Subtle background for headers
    gridLineColor:
        kcLightGrey.withAlpha(100), // Lighter, less prominent grid lines
    gridLineStrokeWidth: 0.3, // Thinner grid lines
    headerHoverColor:
        kcPrimaryColor.withAlpha(20), // Subtle purple tint on header hover
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
