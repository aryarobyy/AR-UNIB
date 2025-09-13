import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel {
  final int? id;
  final String name;
  final String? description;
  final GeoPoint? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BuildingModel({
    this.id,
    required this.name,
    this.description,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  BuildingModel copyWith({
    int? id,
    String? name,
    String? description,
    GeoPoint? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BuildingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BuildingModel.fromMap(Map<String, dynamic> map) {
    return BuildingModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      location: map['location'],
      createdAt: map['created_at'] != null ? (map['created_at'] as Timestamp).toDate() : null,
      updatedAt: map['updated_at'] != null ? (map['updated_at'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
