class TrackModel {
  final String? id;
  final String buildingId;
  final String roomId;
  final List<dynamic> path;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TrackModel({
    this.id,
    required this.buildingId,
    required this.roomId,
    required this.path,
    this.createdAt,
    this.updatedAt,
  });

  TrackModel copyWith({
    String? id,
    String? buildingId,
    String? roomId,
    List<dynamic>? path,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrackModel(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      roomId: roomId ?? this.roomId,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      id: map['id'],
      buildingId: map['building_id'],
      roomId: map['room_id'],
      path: map['path'] is String
          ? List<dynamic>.from([])
          : List<dynamic>.from(map['path']),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'building_id': buildingId,
      'room_id': roomId,
      'path': path,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
