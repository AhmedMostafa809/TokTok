part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}
class MapLoaded extends MapState {
  final LatLng sourceLocation;
  final List<LatLng> destinations;
  final List<LatLng>? routePoints;
  final LatLng? selectedDestination;
  final double zoomLevel;
  final int? timerSeconds;
  final bool showArrivalButton;

  const MapLoaded({
    required this.sourceLocation,
    required this.destinations,
    this.routePoints,
    this.selectedDestination,
    this.zoomLevel = 15.0,
    this.timerSeconds,
    this.showArrivalButton = false,
  });

  @override
  List<Object> get props => [
    sourceLocation,
    destinations,
    zoomLevel,
    showArrivalButton,
    if (routePoints != null) routePoints!,
    if (selectedDestination != null) selectedDestination!,
    if (timerSeconds != null) timerSeconds!,
  ];

  MapLoaded copyWith({
    LatLng? sourceLocation,
    List<LatLng>? destinations,
    List<LatLng>? routePoints,
    LatLng? selectedDestination,
    double? zoomLevel,
    int? timerSeconds,
    bool? showArrivalButton,
  }) {
    return MapLoaded(
      sourceLocation: sourceLocation ?? this.sourceLocation,
      destinations: destinations ?? this.destinations,
      routePoints: routePoints ?? this.routePoints,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      showArrivalButton: showArrivalButton ?? this.showArrivalButton,
    );
  }
}