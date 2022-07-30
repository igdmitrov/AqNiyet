import 'room.dart';
import 'room_details.dart';

class RoomBuild {
  final List<Room> rooms;
  final List<RoomDetails> roomDetails;

  RoomBuild(this.rooms, this.roomDetails);

  List<Room> getActiveRooms() {
    return rooms
        .where((room) =>
            roomDetails.any((roomDetail) => roomDetail.roomId == room.id))
        .toList();
  }

  String lastMessage(String roomId) {
    if (roomDetails.any((element) => element.roomId == roomId)) {
      return roomDetails
          .firstWhere((element) => element.roomId == roomId)
          .content;
    }

    return "";
  }

  int getCount() {
    return rooms
        .where((room) =>
            roomDetails.any((roomDetail) => roomDetail.roomId == room.id))
        .length;
  }
}
