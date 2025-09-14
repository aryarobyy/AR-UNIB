import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meta/meta.dart';
import 'package:ar_unib/model/building_model.dart';
import 'package:ar_unib/services/building_service.dart';

final buildingServiceProvider = Provider((ref) => BuildingService());

@immutable
class BuildingState {
  final bool isLoading;
  final List<BuildingModel> buildings;
  final BuildingModel? selectedBuilding;
  final String? error;

  const BuildingState({
    this.isLoading = false,
    this.buildings = const [],
    this.selectedBuilding,
    this.error,
  });

  BuildingState copyWith({
    bool? isLoading,
    List<BuildingModel>? buildings,
    BuildingModel? selectedBuilding,
    String? error,
  }) {
    return BuildingState(
      isLoading: isLoading ?? this.isLoading,
      buildings: buildings ?? this.buildings,
      selectedBuilding: selectedBuilding ?? this.selectedBuilding,
      error: error ?? this.error,
    );
  }
}

class BuildingNotifier extends StateNotifier<BuildingState> {
  BuildingNotifier(this._service) : super(const BuildingState());

  final BuildingService _service;

  Future<void> fetchAllBuildings() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.getAllBuildings();
      state = state.copyWith(buildings: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchBuilding(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final building = await _service.getBuildingById(id);
      state = state.copyWith(selectedBuilding: building, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addBuilding(BuildingModel building) async {
    try {
      await _service.createBuilding(building);
      await fetchAllBuildings();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateBuilding(BuildingModel building) async {
    try {
      await _service.updateBuilding(building);
      await fetchAllBuildings();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteBuilding(String id) async {
    try {
      await _service.deleteBuilding(id);
      await fetchAllBuildings();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final buildingNotifierProvider =
StateNotifierProvider<BuildingNotifier, BuildingState>(
      (ref) => BuildingNotifier(ref.read(buildingServiceProvider)),
);
