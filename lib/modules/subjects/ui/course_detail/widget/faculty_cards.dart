import 'package:flutter/material.dart';

import '../../../../../widgets/card_stroke.dart';
import '../../../../../widgets/reusables.dart';
import '../../../data/faculty_model.dart';
import 'faculty_card.dart';
// import 'package:hub/data/student/student.dart';
// import 'package:hub/home/ui/widgets/card_stroke.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/course_detail/widget/faculty_card.dart';
// import 'package:hub/widgets/reusables.dart';

class ConnectWithYourFaculty extends StatelessWidget {
  const ConnectWithYourFaculty({Key? key, required this.faculties})
      : super(key: key);

  final List<Faculty> faculties;

  @override
  Widget build(BuildContext context) {
    return CardStroke(
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            final faculty = faculties[index];

            return FacultyCard(faculty: faculty);
          },
          separatorBuilder: (_, index) {
            return CustomDivider(
            );
          },
          itemCount: faculties.length),
    );
  }
}
