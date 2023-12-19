
class SubjectData {
  late int subjectId;
  late String programId;
  late String term;
  late String courseName;
  late int specializationId;

  SubjectData({
    required this.courseName,
    required this.specializationId,
  });

  SubjectData.fromJson(Map<String,dynamic> map){
    subjectId = map['subject_id'] ?? 0;
    programId = map['program'] ?? '';
    term = map['term'] ?? '';
    courseName = map['course_name']??'';
    specializationId = map['specialization_id']??0;
  }
}

