
class UserModel {
  late final String id;
  late final String token;
  late final String email;
  late final String phone;

  UserModel({required this.email});
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    token = json['guid'] ?? '';
    email = json['email'] ?? '';
    phone = json['mobile'] ?? '';
  }
}
