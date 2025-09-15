class RoomModel {
  final String? id;
  final String buildingId;
  final String name;
  final String? roomCode;
  final String? image_url;
  final String? description;
  final int? floor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RoomModel({
    this.id,
    required this.buildingId,
    required this.name,
    this.roomCode,
    this.image_url,
    this.description,
    this.floor,
    this.createdAt,
    this.updatedAt,
  });

  RoomModel copyWith({
    String? id,
    String? buildingId,
    String? name,
    String? roomCode,
    String? image_url,
    String? description,
    int? floor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoomModel(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      name: name ?? this.name,
      roomCode: roomCode ?? this.roomCode,
      image_url: image_url ?? this.image_url,
      description: description ?? this.description,
      floor: floor ?? this.floor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'],
      buildingId: map['building_id'],
      name: map['name'],
      roomCode: map['room_code'],
      image_url: map['image_url'],
      description: map['description'],
      floor: map['floor'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'building_id': buildingId,
      'name': name,
      'room_code': roomCode,
      'image_url': image_url,
      'description': description,
      'floor': floor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
