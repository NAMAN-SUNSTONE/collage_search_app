import 'package:admin_hub_app/modules/content_view/ss_navigation.dart';
import 'package:collection/collection.dart';

class SSAlert {
  SSAlert.fromJson(Map<String, dynamic> json) {
    if (json['type'] == null) {
      type = SSAlertType.dialog;
    } else {
      type = SSAlertType.values.byName(json['type']);
    }
    title = json['title'];
    image = json['image'] ?? '';
    description = json['description'];
    actions = [];
    if (json['actions'] != null) {
      for (var actionData in (json['actions'] as List)) {
        actions.add(SSNavigation.fromJson(actionData));
      }
    }
    isDismissible = json['is_dismissible'] ?? false;
  }

  late SSAlertType type;
  late String title;
  late String description;
  late List<SSNavigation> actions;
  late bool isDismissible;
  late String image;

  SSAlert({
    required this.type,
    required this.image,
    required this.title,
    required this.description,
    required this.actions,
    required this.isDismissible,
  });

  @override
  bool operator ==(Object other) =>
      other is SSAlert &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          description == other.description &&
          ListEquality().equals(actions, other.actions) &&
          isDismissible == other.isDismissible &&
          image == other.image;
}

enum SSAlertType { dialog, navigate }

