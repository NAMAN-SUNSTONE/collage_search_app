import 'package:admin_hub_app/constants/enums.dart';
import 'package:admin_hub_app/modules/subjects/ui/subjects_controller.dart';
import 'package:admin_hub_app/modules/subjects/ui/widgets/program_card.dart';
import 'package:admin_hub_app/widgets/ss_appbar.dart';
import 'package:admin_hub_app/widgets/ss_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';
import '../data/subjects_model.dart';
import '../data/terms_model.dart';
// import 'package:hub/analytics/events.dart';
// import 'package:hub/data/student/models/subjects_model.dart';
// import 'package:hub/data/student/models/terms_model.dart';
// import 'package:hub/routes/app_pages.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_appbar.dart';
// import 'package:hub/sunstone_base/ui/widgets/ss_loader.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/course_detail/subject_detail_controller.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/subjects_controller.dart';
// import 'package:hub/ui/profile/attendance/subjects/ui/widgets/program_card.dart';
// import 'package:hub/utils/layout.dart';

class SubjectsViewNew extends GetView<SubjectsController> {
  const SubjectsViewNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SubjectsController(),
      builder: (controller) {
        return Obx(() {
          return Scaffold(
            // appBar: SHAppBar(title: 'My Subjects', bottom: ProgramCard(
            //   leadingText: controller.courseDetailString,
            //   terms: controller.termsList,
            //   currentTerm: controller.currentTerm,
            //   fetchedTerm: controller.attendanceSubject.value?.currentTerm,
            //   onFilterSelected: controller.onSemesterChange,
            // )),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    "My Subjects",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                // bottom: ProgramCard(
                //   leadingText: controller.courseDetailString,
                //   terms: controller.termsList,
                //   currentTerm: controller.currentTerm,
                //   fetchedTerm: controller.attendanceSubject.value?.currentTerm,
                //   onFilterSelected: controller.onSemesterChange,
                // ),
              ),
            ),
              body: SSLoader.light(
                inAsyncCall: controller.status.value == Status.loading,
                child: _getColumn(),
              ),
            );
        });
      }
    );
  }

  Widget _getColumn() {
    final subjectList = controller.subjectList;
    if (subjectList.isNotEmpty) {
      return ListView.separated(
          itemCount: subjectList.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          separatorBuilder: (_, index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (context, index) {
            final singleSubject = subjectList[index];

            return SubjectCard(
              subject: singleSubject,
              currentTerm: controller.attendanceSubject.value?.currentTerm,
              onTap: () {
                controller.goToDetailPage(singleSubject);
              },
            );
          });
    } else if (controller.status.value != Status.loading) {
      return Column(
        children: [
          const SizedBox(height: 250),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'NO ENTRIES FOUND',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard(
      {Key? key, required this.subject, required this.onTap, required this.currentTerm})
      : super(key: key);
  final Subjects subject;
  final VoidCallback onTap;
  final Terms? currentTerm;


  String get courseType {
    return (subject.specializationId ?? -1) < 0 ? 'Core' : 'Elective';
  }

  String get subtitle {
    return courseType;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 89,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: HubColor.purpleAccent2.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject.courseName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headline5
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
            const Spacer(),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  subtitle,
                  style: context.textTheme.headline5?.copyWith(
                    color: HubColor.purpleAccent2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 25,
                  width: 23,
                  decoration: BoxDecoration(
                      color: HubColor.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Center(
                    child: Text(
                      String.fromCharCode(
                          Icons.arrow_forward_ios_rounded.codePoint),
                      style: TextStyle(
                        inherit: false,
                        fontWeight: FontWeight.w600,
                        fontFamily: Icons.arrow_forward_ios_rounded.fontFamily,
                        color: HubColor.primary,
                        package: Icons.arrow_forward_ios_rounded.fontPackage,
                      ),
                    ),
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
