import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meta/meta.dart';
import 'package:ar_unib/model/room_model.dart';
import 'package:ar_unib/services/room_service.dart';

final roomServiceProvider = Provider((ref) => RoomService());

@immutable
class RoomState {
  final bool isLoading;
  final List<RoomModel> rooms;
  final RoomModel? room;
  final String? error;

  const RoomState({
    this.isLoading = false,
    this.rooms = const [],
    this.room,
    this.error,
  });

  RoomState copyWith({
    bool? isLoading,
    List<RoomModel>? rooms,
    RoomModel? room,
    String? error,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      rooms: rooms ?? this.rooms,
      room: room ?? this.room,
      error: error ?? this.error,
    );
  }
}

class RoomNotifier extends StateNotifier<RoomState> {
  RoomNotifier(this._service) : super(const RoomState());

  final RoomService _service;

  Future<void> fetchAllRooms() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.getAllRooms();
      state = state.copyWith(rooms: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchRoomsByBuilding(String buildingId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.getRoomsByBuildingId(buildingId);
      state = state.copyWith(rooms: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchRoom(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final room = await _service.getRoomById(id);
      state = state.copyWith(room: room, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addRoom(RoomModel room) async {
    try {
      await _service.createRoom(room);
      await fetchAllRooms();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    try {
      await _service.updateRoom(room);
      await fetchAllRooms();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteRoom(String id) async {
    try {
      await _service.deleteRoom(id);
      await fetchAllRooms();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final roomNotifierProvider =
StateNotifierProvider<RoomNotifier, RoomState>(
      (ref) => RoomNotifier(ref.read(roomServiceProvider)),
);
