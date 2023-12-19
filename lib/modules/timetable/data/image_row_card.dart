// import 'package:hub/data/student/models/target_model.dart';

import 'package:admin_hub_app/modules/content_view/target_model.dart';

class ImageRowCard {
  late final String title;
  late final String? description;
  late final StoryImages image;
  late final Target target;

  ImageRowCard.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = StoryImages.fromJson(json['image'] ?? {});
    target = Target.fromJson(json['target'] ?? {});
  }
}

class StoryImages {
  late final String? small;
  late final String? medium;
  late final String? large;

  StoryImages.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
  }
}
