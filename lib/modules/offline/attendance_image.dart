class AttendanceImage {
  final int id;
  final int eventId;
  final String path;

  const AttendanceImage(
      {required this.id, required this.eventId, required this.path});

  factory AttendanceImage.fromJson(Map<String, dynamic> json) {
    return AttendanceImage(
        id: json['id'], eventId: json['event_id'], path: json['path']);
  }
}
