// import './lecture_category_model.dart';

import 'package:admin_hub_app/modules/content_view/lecture_category_model.dart';

class EventMonth {
  List<EventDateModel> dates;

  EventMonth({
    required this.dates,
  });
}

class EventDateModel {
  String dateLabel;
  int date;
  List<LectureCategoryModel> category;

  EventDateModel({
    required this.dateLabel,
    required this.date,
    required this.category,
  });
}
