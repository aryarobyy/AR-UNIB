import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel {
  final String? id;
  final String name;
  final String? description;
  final GeoPoint? location;
  final String? imageUrl;
  final List<String>? roomsId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BuildingModel({
    this.id,
    required this.name,
    this.description,
    this.location,
    this.imageUrl,
    this.roomsId,
    this.createdAt,
    this.updatedAt,
  });

  BuildingModel copyWith({
    String? id,
    String? name,
    String? description,
    GeoPoint? location,
    List<String>? roomsId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BuildingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      roomsId: roomsId ?? this.roomsId,
      imageUrl: imageUrl ?? this.imageUrl,
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
      roomsId: map['roomsId'],
      imageUrl: map['imageUrl'],
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
      'roomsId': roomsId,
      'imageUrl': imageUrl,
      'location': location,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
