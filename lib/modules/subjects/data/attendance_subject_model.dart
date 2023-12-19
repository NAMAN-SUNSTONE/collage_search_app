// import 'package:hub/data/student/models/subjects_model.dart';
// import 'package:hub/data/student/models/terms_model.dart';

import 'package:admin_hub_app/modules/subjects/data/subjects_model.dart';
import 'package:admin_hub_app/modules/subjects/data/terms_model.dart';

class AttendanceSubject {
  List<Terms> termsList;
  Terms currentTerm;
  List<Subjects> subjects;

  AttendanceSubject({
    required this.termsList,
    required this.currentTerm,
    required this.subjects,
  });

  factory AttendanceSubject.fromJson(Map<String, dynamic> json) {
    return AttendanceSubject(
        termsList:
            (json['terms'] as List?)?.map((e) => Terms.fromJson(e)).toList() ??
                [],
        currentTerm: Terms.fromJson(json['current_term']),
        subjects: (json['subjects'] as List?)
                ?.map((e) => Subjects.fromJson(e))
                .toList() ??
            []);
  }
}
