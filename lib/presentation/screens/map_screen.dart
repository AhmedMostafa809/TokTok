//
// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//
//   final Completer<GoogleMapController> _mapController = Completer();
//   BitmapDescriptor? sourceIcon;
//   BitmapDescriptor? driverIcon;
//   final PolylinePoints polylinePoints = PolylinePoints();
//
//   List<LatLng> polylineCoordinates = [];
//   void getPolyPoints() async {
//     try {
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         request: PolylineRequest(origin:PointLatLng(30.0228051, 31.4037249)
//             , destination: PointLatLng(30.0163959, 31.4012811),
//             mode:  TravelMode.driving,optimizeWaypoints: true),
//         googleApiKey: "AIzaSyDVRGP-WivRuIlNAiVrbped6wn5vWUMrVk",
//       );
//       if (result.points.isNotEmpty) {
//         setState(() {
//         });
//         polylineCoordinates = result.points
//             .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
//             .toList();
//
//       }
//     } catch (e) {
//       print(e);
//
//     }
//
//
//   }
//
//
//   void setMarkers()  {
//     BitmapDescriptor.asset(
//       ImageConfiguration(size: Size(30, 40) ),
//       "assets/current_location.png",
//     ).then((icon) {
//       setState(() {
//         sourceIcon = icon;
//       });
//     });
//     BitmapDescriptor.asset(
//       ImageConfiguration(size: Size(60, 40) ),
//       "assets/toktok.png",
//     ).then((icon) {
//       setState(() {
//         driverIcon = icon;
//       });
//     });
//   }
//   @override
//   void initState() {
//     setMarkers();
//     getPolyPoints();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.terrain,
//         myLocationButtonEnabled: true,
//         myLocationEnabled: true,
//         compassEnabled: true,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(30.0228051, 31.4037249),
//           zoom: 14,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _mapController.complete(controller);
//         },
//         polylines: {
//           Polyline(
//             polylineId: PolylineId('route'),
//             points: polylineCoordinates,
//             color: Colors.blue,
//             width: 3,
//           ),
//         },
//         markers: {
//           Marker(
//             markerId: MarkerId('1'),
//             position: LatLng(30.0228051, 31.4037249),
//             icon: sourceIcon!,
//           ),
//           Marker(
//             markerId: MarkerId('1'),
//             position: LatLng(30.0163959, 31.4012811),
//             icon: driverIcon!,
//           )
//         },
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _FreeMapScreenState createState() => _FreeMapScreenState();
}

class _FreeMapScreenState extends State<MapScreen> {
  final LatLng sourceLocation = LatLng(30.0228051, 31.4037249);
  final LatLng destinationLocation = LatLng(30.0163959, 31.4012811);
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    getRoute();
  }

  Future<void> getRoute() async {
    final url =
        'http://router.project-osrm.org/route/v1/driving/${sourceLocation.longitude},${sourceLocation.latitude};${destinationLocation.longitude},${destinationLocation.latitude}?overview=full&geometries=geojson';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final coordinates = decoded['routes'][0]['geometry']['coordinates'];
      List<LatLng> points = coordinates
          .map<LatLng>((point) => LatLng(point[1], point[0]))
          .toList();

      setState(() {
        routePoints = points;
      });
    } else {
      print('Failed to fetch route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: sourceLocation,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 50,
                height: 50,
                point: sourceLocation,
                child:  Image.asset("assets/current_location.png",),
              ),
              Marker(
                width: 50,
                height: 50,
                point: destinationLocation,
                child:  Image.asset( "assets/toktok.png", ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
