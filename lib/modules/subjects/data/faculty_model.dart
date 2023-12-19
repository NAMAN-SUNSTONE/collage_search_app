class Faculty {
  late String name;
  late String picture;
  late List<String> degrees;
  late String email;
  late List<Expertise> expertise;

  Faculty({
    required this.name,
    required this.picture,
    required this.degrees,
    required this.email,
  });
  Faculty.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    picture = json['picture'] ?? "";
    degrees = json['degrees']?.cast<String>() ?? const [];
    email = json['email'] ?? "";
    expertise = (json['expertises'] as List?)?.map((e) => Expertise.fromJson(e)).toList() ?? [];
  }
  toJson() {
    Map<String, dynamic> _json = <String, dynamic>{};
    _json['name'] = name;
    _json['picture'] = picture;
    _json['degrees'] = degrees;
    _json['email'] = email;
    return _json;
  }
}

class Expertise {
  final int? id;
  final String expertise;

  Expertise({this.id, required this.expertise});

  factory Expertise.fromJson(Map json) {
    return Expertise(id: json['id'], expertise: json['name']);
  }
}