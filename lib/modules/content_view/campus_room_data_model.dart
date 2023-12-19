class CampusRoomDataModel {
  late String roomNo;

  CampusRoomDataModel({
    required this.roomNo,
  });

  CampusRoomDataModel.fromJson(Map<String, dynamic> json) {
    roomNo = json['room_no']??'';
  }
}
