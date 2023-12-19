import 'package:admin_hub_app/modules/attendance_report/model/academic_content_model.dart';

class TaughtLectureModel {
  const TaughtLectureModel(
      {required this.lecture, required this.isSelected, required this.type});

  final LectureModel lecture;
  final bool isSelected;
  final TaughtLectureType type;
}

enum TaughtLectureType { regular, other, not_mentioned, display }
