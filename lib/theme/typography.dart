import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

abstract class HubTypography {
  static final _headline1 = GoogleFonts.publicSans(
    fontSize: 99,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    color: HubColor.primaryText,
  );

  static final _headline2 = GoogleFonts.publicSans(
    fontSize: 62,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: HubColor.primaryText,
  );

  static final _headline3 = GoogleFonts.publicSans(
    fontSize: 49,
    fontWeight: FontWeight.w600,
    color: HubColor.secondaryText,
  );

  static final _headline4 = GoogleFonts.publicSans(
    fontSize: 35,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    color: HubColor.primaryText,
  );

  static final _headline5 = GoogleFonts.publicSans(
    fontSize: 25,
    fontWeight: FontWeight.w400,
    color: HubColor.primaryText,
  );

  static final _headline6 = GoogleFonts.publicSans(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: HubColor.primaryText,
  );

  static final _subtitle1 = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: HubColor.secondaryText,
  );

  static final _subtitle2 = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: HubColor.secondaryText,
  );

  static final _bodyText1 = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: HubColor.primaryText,
  );

  static final _bodyText2 = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: HubColor.primaryText,
  );

  static final _button = GoogleFonts.publicSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: HubColor.filledButtonText,
  );

  static final _caption = GoogleFonts.publicSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: HubColor.primaryText,
  );

  static final _overline = GoogleFonts.publicSans(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: HubColor.primaryText,
  );

  static get hubTextTheme => TextTheme(
      headline1: _headline1,
      headline2: _headline2,
      headline3: _headline3,
      headline4: _headline4,
      headline5: _headline5,
      headline6: _headline6,
      subtitle1: _subtitle1,
      subtitle2: _subtitle2,
      bodyText1: _bodyText1,
      bodyText2: _bodyText2,
      button: _button,
      caption: _caption,
      overline: _overline);
}
