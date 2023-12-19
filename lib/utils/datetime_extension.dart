import 'package:admin_hub_app/utils/string_extension.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var weekOfMonth = 0;
    var date = this;

    while (date.month == month) {
      weekOfMonth++;
      date = date.subtract(const Duration(days: 7));
    }

    return weekOfMonth;
  }

  bool isSameYear(DateTime other) => this.year == other.year;

  bool isSameMonth(DateTime other) =>
      this.isSameYear(other) && this.month == other.month;

  bool isSameDate(DateTime other) =>
      this.isSameMonth(other) && this.day == other.day;

  String? format(String pattern, {bool lowerCaseMeridiem = false}) {
    try {
      final DateFormat formatter = DateFormat(pattern);
      String _formattedDateTime = formatter.format(this);
      if (lowerCaseMeridiem) {
        _formattedDateTime = _lowerCaseMeridiem(_formattedDateTime);
      }
      return _formattedDateTime;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  String _lowerCaseMeridiem(String formattedString) {
    return formattedString.replaceFirst("AM", "am").replaceFirst("PM", "pm");
  }

  String formatInSStandard() {
    DateFormat dt = DateFormat("dd MMM''yy'");

    return dt.format(this);
  }

  Duration differenceFromCurrentTime() {
    return difference(DateTime.now());
  }

  String toServerFormat() {
    DateFormat format = DateFormat(StringExt.standardDateTimeFormat);
    return format.format(this);
  }

  String toReadableDate({bool showDate = true, bool showTime = true}) {
    DateTime inputDate = DateTime.parse(this.toString()).toLocal();

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
}
