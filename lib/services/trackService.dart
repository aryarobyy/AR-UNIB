import 'package:ar_unib/model/track_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackService {
  final CollectionReference _trackRef =
      FirebaseFirestore.instance.collection('tracks');

  Future<void> createTrack(TrackModel track) async {
    await _trackRef.doc(track.id.toString()).set(track.toMap());
  }

  Future<List<TrackModel>> getAllTracks() async {
    final snapshot = await _trackRef.get();
    return snapshot.docs
        .map((doc) => TrackModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<TrackModel>> getTracksByBuildingId(int buildingId) async {
    final snapshot =
        await _trackRef.where('building_id', isEqualTo: buildingId).get();
    return snapshot.docs
        .map((doc) => TrackModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<TrackModel>> getTracksByRoomId(int roomId) async {
    final snapshot =
        await _trackRef.where('room_id', isEqualTo: roomId).get();
    return snapshot.docs
        .map((doc) => TrackModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<TrackModel?> getTrackById(int id) async {
    final doc = await _trackRef.doc(id.toString()).get();
    if (doc.exists) {
      return TrackModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateTrack(TrackModel track) async {
    await _trackRef.doc(track.id.toString()).update(track.toMap());
  }

  Future<void> deleteTrack(int id) async {
    await _trackRef.doc(id.toString()).delete();
  }
}
