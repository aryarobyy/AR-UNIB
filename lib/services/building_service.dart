import 'package:ar_unib/model/building_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingService {
  final CollectionReference _buildingRef =
  FirebaseFirestore.instance.collection('buildings');

  Future<void> createBuilding(BuildingModel building) async {
    await _buildingRef.doc(building.id.toString()).set(building.toMap());
  }

  Future<List<BuildingModel>> getAllBuildings() async {
    final snapshot = await _buildingRef.get();
    return snapshot.docs
        .map((doc) => BuildingModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<BuildingModel?> getBuildingById(int id) async {
    final doc = await _buildingRef.doc(id.toString()).get();
    if (doc.exists) {
      return BuildingModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateBuilding(BuildingModel building) async {
    await _buildingRef.doc(building.id.toString()).update(building.toMap());
  }

  Future<void> deleteBuilding(int id) async {
    await _buildingRef.doc(id.toString()).delete();
  }
}
