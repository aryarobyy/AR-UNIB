import 'package:ar_unib/model/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomService {
  final CollectionReference _roomRef =
  FirebaseFirestore.instance.collection('rooms');

  Future<void> createRoom(RoomModel room) async {
    await _roomRef.doc(room.id.toString()).set(room.toMap());
  }

  Future<List<RoomModel>> getAllRooms() async {
    final snapshot = await _roomRef.get();
    return snapshot.docs
        .map((doc) => RoomModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<RoomModel>> getRoomsByBuildingId(int buildingId) async {
    final snapshot =
    await _roomRef.where('building_id', isEqualTo: buildingId).get();
    return snapshot.docs
        .map((doc) => RoomModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<RoomModel?> getRoomById(int id) async {
    final doc = await _roomRef.doc(id.toString()).get();
    if (doc.exists) {
      return RoomModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateRoom(RoomModel room) async {
    await _roomRef.doc(room.id.toString()).update(room.toMap());
  }

  Future<void> deleteRoom(int id) async {
    await _roomRef.doc(id.toString()).delete();
  }
}
