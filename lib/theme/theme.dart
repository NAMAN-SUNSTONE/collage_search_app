import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'typography.dart';

const hubColorScheme = ColorScheme(
  primary: HubColor.primary,
  // primaryVariant: HubColor.primaryLight,
  secondary: HubColor.secondary,
  // secondaryVariant: HubColor.secondaryLight,
  surface: HubColor.primaryTint,
  background: HubColor.white,
  error: HubColor.redDark,
  onPrimary: HubColor.white,
  onSecondary: HubColor.primaryText,
  onSurface: HubColor.primaryText,
  onBackground: HubColor.primaryLight,
  onError: HubColor.white,
  brightness: Brightness.light,
);

final hubTheme = ThemeData.light().copyWith(
  colorScheme: hubColorScheme,
  brightness: Brightness.light,
  scaffoldBackgroundColor: hubColorScheme.background,
  textTheme: HubTypography.hubTextTheme,
  cardTheme: CardTheme(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
  appBarTheme: AppBarTheme(
    elevation: 1,
    foregroundColor: hubColorScheme.primary,
    backgroundColor: hubColorScheme.background,
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: hubColorScheme.surface,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: hubColorScheme.primary,
    unselectedItemColor: HubColor.disabledText,
    selectedLabelStyle: HubTypography.hubTextTheme.caption,
    unselectedLabelStyle: HubTypography.hubTextTheme.caption,
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
    showSelectedLabels: true,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: hubColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(120, 44)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return hubColorScheme.primary;
        }
        return null;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color(0xFFE0E0E0);
        }
        return null;
      }),
    ),
  ),
  checkboxTheme: ThemeData.light().checkboxTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: const Color(0xFFC4C4C4), width: 1),
        ),
      ),
  dividerColor: Colors.transparent,
  dividerTheme: DividerThemeData(color: Colors.transparent),
);
