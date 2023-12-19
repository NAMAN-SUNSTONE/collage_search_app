import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hub/constants/screen_names.dart';
// import 'package:hub/data/student/models/lecture_model.dart';
// import 'package:hub/ui/home/home_controller.dart';
// import 'package:hub/ui/timetable/widgets/single_lecture_widget.dart';

import '../../../../content_view/lecture_model.dart';

class RecentClasses extends StatelessWidget {

  const RecentClasses({Key? key, required this.recentClasses})
      : super(key: key);

  final List<LectureEventListModel> recentClasses;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int index = 0; index < recentClasses.length; index++)
            Text(recentClasses[index].displayTitle)
            // LectureCardSingle(
            //   data: recentClasses[index],
            //   screenName: ScreenName.subjectDetails,
            //   publisher: Get.find<HomeController>().publisher,
            //   cardSequence: index,
            //   widthFactor: (recentClasses.length == 1 ? 1 : 0.87),
            //   padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 16),
            //   showFlexibleItems: false,
            // ),
        ],
      ),
    );
  }
}