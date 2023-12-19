class UUIDParams {
  final String classId;

  ///date format
  ///2022-12-31
  final String lectureDate;

  ///time format
  ///08:00:00
  final String lectureStartTime;

  UUIDParams(
      {required this.classId,
      required this.lectureDate,
      required this.lectureStartTime});
}

///UUID format
/// 71239817a2022b12b31a08b00b00a000
/// 71239817 2022b12b31 08b00b00 000
/// 71239817 2022-12-31 08:00:00
/// classId      date     time

class UUIDUtils {
  static String encode(UUIDParams data) {
    final String date = data.lectureDate.replaceAll('-', 'b');
    final String time = data.lectureStartTime.replaceAll(':', 'b');
    final String classId = data.classId;

    String result = "${classId}a${date}a${time}a";
    while (result.length < 32) {
      result += '0';
    }
    return result;
  }

  static UUIDParams decode(String uuid) {
    final List<String> array = uuid.split('a');
    final String classId = array[0];
    final String date = array[1].replaceAll('b', '-');
    final String time = array[2].replaceAll('b', ':');

    return UUIDParams(
        classId: classId, lectureDate: date, lectureStartTime: time);
  }


  ///Formats the UUID into standard format
  /// Sample input  :  7747a2023b05b22a15b20b00a0000000
  /// Sample output  :  7747a202-3b05-b22a-15b2-0b00a0000000
  static String format(String input) {
    if (input.length < 32) return input;

    StringBuffer buffer = StringBuffer();
    buffer.write(input.substring(0, 8));
    buffer.write('-');
    buffer.write(input.substring(8, 12));
    buffer.write('-');
    buffer.write(input.substring(12, 16));
    buffer.write('-');
    buffer.write(input.substring(16, 20));
    buffer.write('-');
    buffer.write(input.substring(20));

    return buffer.toString();
  }
}
