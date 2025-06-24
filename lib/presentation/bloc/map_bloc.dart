import 'dart:async';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final Dio dio = Dio();
  Timer? timer;
  final LatLng sourceLocation = LatLng(30.0228051, 31.4037249);
  final List<LatLng> destinations = [
    LatLng(30.0163959, 31.4012811),
    LatLng(30.0165056, 31.4109344),
    LatLng(30.037725, 31.404627),
  ];

  MapBloc() : super(MapInitial()) {
    on<MapInitialized>(onMapInitialized);
    on<MarkerTapped>(onMarkerTapped);
    on<ZoomIn>(onZoomIn);
    on<ZoomOut>(onZoomOut);
    on<StartDriverTimer>(onStartDriverTimer);
    on<TimerTicked>(onTimerTicked);
    on<TimerCompleted>(onTimerCompleted);
    on<NavigateToDestination>(onNavigateToDestination);
  }

  // @override
  // Future<void> close() {
  //   timer?.cancel();
  //   return super.close();
  // }

  void onMapInitialized(MapInitialized event, Emitter<MapState> emit) {
    emit(MapLoaded(
      sourceLocation: sourceLocation,
      destinations: destinations,
    ));
  }

  Future<void> onMarkerTapped(MarkerTapped event, Emitter<MapState> emit) async {
    final currentState = state as MapLoaded;
    try {
      final url = 'http://router.project-osrm.org/route/v1/driving/'
          '${sourceLocation.longitude},${sourceLocation.latitude};'
          '${event.destination.longitude},${event.destination.latitude}'
          '?overview=full&geometries=geojson';
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decoded = response.data;
        final coordinates = decoded['routes'][0]['geometry']['coordinates'];
        List<LatLng> points = coordinates
            .map<LatLng>((point) => LatLng(point[1], point[0]))
            .toList();
        emit(currentState.copyWith(
          routePoints: points,
          selectedDestination: event.destination,
        ));
        add(StartDriverTimer(event.destination));
      }
    } catch (e) {
      print('Failed to fetch route: $e');
    }
  }

  void onStartDriverTimer(StartDriverTimer event, Emitter<MapState> emit) {
    final currentState = state as MapLoaded;
    timer?.cancel();
    int secondsRemaining = 10;
    emit(currentState.copyWith(
      timerSeconds: secondsRemaining,
      showArrivalButton: false,
    ));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsRemaining--;
      if (secondsRemaining > 0) {
        add(TimerTicked(secondsRemaining));
      } else {
        add(TimerCompleted());
        timer.cancel();
      }
    });
  }

  void onTimerTicked(TimerTicked event, Emitter<MapState> emit) {
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(timerSeconds: event.secondsRemaining));
  }

  void onTimerCompleted(TimerCompleted event, Emitter<MapState> emit) {
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(
      timerSeconds: 0,
      showArrivalButton: true,
    ));
  }

  void onNavigateToDestination(NavigateToDestination event, Emitter<MapState> emit) {
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(showArrivalButton: false));
  }


  void onZoomIn(ZoomIn event, Emitter<MapState> emit) {
    final currentState = state as MapLoaded;

    emit(currentState.copyWith(
      zoomLevel: currentState.zoomLevel + 0.5,
    ));
  }

  void onZoomOut(ZoomOut event, Emitter<MapState> emit) {
    final currentState = state as MapLoaded;
    emit(currentState.copyWith(
      zoomLevel: currentState.zoomLevel - 0.5,
    ));
  }
}