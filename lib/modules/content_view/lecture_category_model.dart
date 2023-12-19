class LectureCategoryModel {
  final String identifier;
  final String label;
  final String bgColor;
  final String fgColor;
  final String cardColor;
  final String accentColor;

  LectureCategoryModel(
      {required this.identifier,
      required this.label,
      required this.bgColor,
      required this.fgColor,
      required this.cardColor,
      required this.accentColor});

  factory LectureCategoryModel.fromJson(Map<String, dynamic> json) {
    String identifier = json['identifier'] ?? '';
    String label = json['label'] ?? '';
    String bgColor = json['bg_color'] ?? '';
    String fgColor = json['fg_color'] ?? '';
    String cardColor = json['card_color'] ?? '';
    String accentColor = json['accent_color'] ?? '';

    return LectureCategoryModel(
        identifier: identifier,
        label: label,
        bgColor: bgColor,
        fgColor: fgColor,
        cardColor: cardColor,
        accentColor: accentColor);
  }
}
