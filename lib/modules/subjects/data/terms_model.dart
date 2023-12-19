class TermsModel {
  TermsModel({
    required this.termsList,
    required this.currentTerm,
  });

  TermsModel.fromJson(Map<String, dynamic> json) {
    termsList = json['terms'] == null
        ? const []
        : json['terms'].map((e) => Terms.fromJson(e)).toList().cast<Terms>();
    currentTerm = (json['current_term'] == null || json['current_term'].isEmpty)
        ? null
        : Terms.fromJson(json['current_term']);
  }

  late final List<Terms> termsList;
  late final Terms? currentTerm;
}

class Terms {
  Terms({
    required this.label,
    required this.type,
    required this.termNo,
  });

  Terms.fromJson(Map<String, dynamic> json) {
    label = json['label'] ?? '';
    type = json['type'] ?? '';
    termNo = json['term_number'] ?? 0;
  }

  late String label;
  late String type;
  late int termNo;

  toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json['label'] = label;
    json['type'] = type;
    json['term_number'] = termNo;
    return json;
  }
}
