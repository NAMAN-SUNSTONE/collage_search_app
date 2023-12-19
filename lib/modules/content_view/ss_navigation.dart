class SSNavigation {
  SSNavigation.fromJson(Map<String, dynamic> json) {
    type = SSNavigationType.values.byName(json['type']);
    title = json['title'];
    iconIdentifier = json['icon_identifier'];
    deeplink = json['deeplink'];
    if (json['data_type'] != null) {
      dataType = SSDetailDataType.values.byName(json['data_type']);
    }
    data = json['data'];
  }

  late SSNavigationType type;
  late String title;
  late String? iconIdentifier;
  late String deeplink;
  late SSDetailDataType? dataType;
  late dynamic data;
  Function? onTap;

  SSNavigation(
      {required this.type,
      required this.title,
      required this.iconIdentifier,
      required this.deeplink,
      this.dataType,
      this.data,
      this.onTap});

  toJson() {
    Map<String, dynamic> _json = <String, dynamic>{};
    _json['type'] = type;
    _json['title'] = title;
    _json['icon_identifier'] = iconIdentifier;
    _json['deeplink'] = deeplink;
    _json['data_type'] = dataType?.name;
    _json['data'] = data.toString();
    return _json;
  }

  @override
  bool operator ==(Object other) =>
      other is SSNavigation &&
      runtimeType == other.runtimeType &&
      type == other.type &&
      title == other.title &&
      iconIdentifier == other.iconIdentifier &&
      deeplink == other.deeplink &&
      dataType == other.dataType &&
      data == other.data;

  @override
  int get hashCode =>
      type.hashCode *
      title.hashCode *
      iconIdentifier.hashCode *
      deeplink.hashCode *
      dataType.hashCode *
      data.hashCode;
}

enum SSNavigationType { primary, secondary, link, text, textRow, primaryDisabled, secondaryDisabled, icon }

enum SSDetailDataType { job_round_info, referral_send_fly_reminder }
