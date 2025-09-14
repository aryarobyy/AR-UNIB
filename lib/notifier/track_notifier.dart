import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meta/meta.dart';
import 'package:ar_unib/model/track_model.dart';
import 'package:ar_unib/services/track_service.dart';

final trackServiceProvider = Provider((ref) => TrackService());

@immutable
class TrackState {
  final bool isLoading;
  final List<TrackModel> tracks;
  final TrackModel? selectedTrack;
  final String? error;

  const TrackState({
    this.isLoading = false,
    this.tracks = const [],
    this.selectedTrack,
    this.error,
  });

  TrackState copyWith({
    bool? isLoading,
    List<TrackModel>? tracks,
    TrackModel? selectedTrack,
    String? error,
  }) {
    return TrackState(
      isLoading: isLoading ?? this.isLoading,
      tracks: tracks ?? this.tracks,
      selectedTrack: selectedTrack ?? this.selectedTrack,
      error: error ?? this.error,
    );
  }
}

class TrackNotifier extends StateNotifier<TrackState> {
  TrackNotifier(this._service) : super(const TrackState());

  final TrackService _service;

  Future<void> fetchAllTracks() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.getAllTracks();
      state = state.copyWith(tracks: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchTracksByBuilding(String buildingId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.getTracksByBuildingId(buildingId);
      state = state.copyWith(tracks: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchTracksByRoom(String roomId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.getTracksByRoomId(roomId);
      state = state.copyWith(tracks: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchTrack(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final track = await _service.getTrackById(id);
      state = state.copyWith(selectedTrack: track, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addTrack(TrackModel track) async {
    try {
      await _service.createTrack(track);
      await fetchAllTracks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateTrack(TrackModel track) async {
    try {
      await _service.updateTrack(track);
      await fetchAllTracks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTrack(String id) async {
    try {
      await _service.deleteTrack(id);
      await fetchAllTracks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final trackNotifierProvider =
StateNotifierProvider<TrackNotifier, TrackState>(
      (ref) => TrackNotifier(ref.read(trackServiceProvider)),
);
