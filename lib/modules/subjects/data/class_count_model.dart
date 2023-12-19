class ClassCount {
  late int absent;
  late int present;
  late int unmarked;

  ClassCount({
    required this.absent,
    required this.present,
    required this.unmarked,
  });

  ClassCount.fromJson(Map<String, dynamic> json) {
    absent = json['absent'] ?? 0;
    present = json['present'] ?? 0;
    unmarked = json['unmarked'] ?? 0;
  }
  toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['absent'] = absent;
    json['present'] = present;
    json['unmarked'] = unmarked;
    return json;
  }
}
