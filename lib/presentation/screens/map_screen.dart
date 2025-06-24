import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toktokapp/presentation/bloc/map_bloc.dart';
import 'package:toktokapp/presentation/screens/arrival_screen.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late final MapController mapController;
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => isMapReady = true);
        context.read<MapBloc>().add(MapInitialized());
      }
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (isMapReady && state is MapLoaded) {
            mapController.move(state.sourceLocation, state.zoomLevel);
          }
          // if (state is MapLoaded && state.showArrivalButton) {
          // }
        },
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (!isMapReady || state is MapInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MapLoaded) {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: state.sourceLocation,
                      initialZoom: state.zoomLevel,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      if (state.routePoints != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: state.routePoints!,
                              color: Colors.black,
                              strokeWidth: 5.0,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 50,
                            height: 50,
                            point: state.sourceLocation,
                            child: Image.asset("assets/current_location.png"),
                          ),
                          ...state.destinations.map((destination) => Marker(
                            width: 50,
                            height: 50,
                            point: destination,
                            child: GestureDetector(
                              onTap: () => context.read<MapBloc>().add(MarkerTapped(destination)),
                              child: Image.asset(
                                "assets/toktok.png",
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  if (state.timerSeconds != null)
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(155),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'TokTok arriving in: ${state.timerSeconds}s',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (state.showArrivalButton)
                    Positioned(
                      bottom: 100,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            context.read<MapBloc>().add(NavigateToDestination());
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArrivalScreen(
                                  destination: state.selectedDestination!,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'On My Way',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 16,
                    bottom: 100,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: 'zoomIn',
                          mini: true,
                          onPressed: () => context.read<MapBloc>().add(ZoomIn()),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton(
                          heroTag: 'zoomOut',
                          mini: true,
                          onPressed: () => context.read<MapBloc>().add(ZoomOut()),
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}


