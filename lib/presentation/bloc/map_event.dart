part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object> get props => [];
}

class MapInitialized extends MapEvent {}
class MarkerTapped extends MapEvent {
  final LatLng destination;
  const MarkerTapped(this.destination);
}
class MapTapped extends MapEvent {}
class ZoomIn extends MapEvent {}
class ZoomOut extends MapEvent {}
class StartDriverTimer extends MapEvent {
  final LatLng destination;
  const StartDriverTimer(this.destination);
}
class TimerTicked extends MapEvent {
  final int secondsRemaining;
  const TimerTicked(this.secondsRemaining);
}
class TimerCompleted extends MapEvent {}
class NavigateToDestination extends MapEvent {}