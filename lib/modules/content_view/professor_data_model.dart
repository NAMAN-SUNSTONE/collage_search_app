class ProfessorDataModel {
  late String name;

  ProfessorDataModel({
    required this.name,
  });
  ProfessorDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name']??'';
  }
}
