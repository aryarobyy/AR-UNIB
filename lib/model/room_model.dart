class RoomModel {
  final int? id;
  final int buildingId;
  final String name;
  final String? roomCode;
  final String? description;
  final int? floor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RoomModel({
    this.id,
    required this.buildingId,
    required this.name,
    this.roomCode,
    this.description,
    this.floor,
    this.createdAt,
    this.updatedAt,
  });

  RoomModel copyWith({
    int? id,
    int? buildingId,
    String? name,
    String? roomCode,
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
      'description': description,
      'floor': floor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
