import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExt on String {

  static const String standardDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const String ddmmyyyyFormat = 'dd-MM-yyyy';
  static const String yyyymmddFormat = 'yyyy-MM-dd';

  //Method To Convert a String into Camel Case Form.
  String capitalize() {
    var c = '';
    var a = this.toLowerCase().split(' ');

    for (String b in a) {
      if (b.length > 1) {
        c = c + b.substring(0, 1).toUpperCase() + b.substring(1) + ' ';
      } else {
        c = c + b.substring(0).toUpperCase();
      }
    }
    return c;
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidUrl() {
    return RegExp(
            r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?')
        .hasMatch(this);
  }

  /// check if the string contains only numbers
  bool isNumeric() {
    return RegExp(r'^-?[0-9]+$').hasMatch(this);
  }

  String get orEmpty => this == null ? '' : '$this';

  @Deprecated('use toColor2 instead')
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('FF');
    buffer.write(replaceFirst('#', ''));
    final colorInt = int.parse(buffer.toString(), radix: 16);
    return Color(colorInt);
  }

  Color toColor2() {
    if(this=="") return Color(0xff000000);
      final buffer = StringBuffer();
      if (length == 6 || length == 7) buffer.write('FF');
      buffer.write(replaceFirst('#', ''));
      final colorInt = int.parse(buffer.toString(), radix: 16);
      return Color(colorInt);
    }

    String toReadableDate({bool showDate = true, bool showTime = true}) {

    DateTime parseDate = DateFormat(standardDateTimeFormat).parse(this, true);

    DateTime inputDate = DateTime.parse(parseDate.toString()).toLocal();

    DateFormat outputFormat;

    if (showDate && showTime) {
      outputFormat = DateFormat("dd MMM''yy', 'hh:mm a'");
    } else if (showDate) {
      outputFormat = DateFormat("dd MMM''yy'");
    } else {
      outputFormat = DateFormat("hh:mm a");
    }
    return outputFormat.format(inputDate);
  }

  int toEpoch() {

    DateTime parseDate = DateFormat(standardDateTimeFormat).parse(this, true);
    DateTime inputDate = DateTime.parse(parseDate.toString()).toLocal();

    return inputDate.millisecondsSinceEpoch;
  }

  DateTime toDateTime({String dateFormat = standardDateTimeFormat}) => DateFormat(dateFormat).parse(this, true).toLocal();

  ///converts [String] into [DateTime]
  ///returns null in case of parsing failure
  DateTime? toDateTimeObject() {
    try {
      return DateTime.parse(this).toLocal();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  bool get isNotNull => this.trim() != null.toString();

  String get shortFileNameWithExtension{
    final splitFileName = this.split('/').last.split('.');
    final String extension = splitFileName.last ?? '';
    final String fileName = splitFileName.first ?? '';

    //if long file name then trim it
    if (fileName.length > 20) {
      return fileName.substring(0, 14) +
          '...${fileName.substring(14, 18)}.$extension';
    } else {
      return fileName + '.$extension';
    }
  }

}

extension NullableStringExt on String? {
  String get orEmpty => this == null ? '' : '$this';
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
}
